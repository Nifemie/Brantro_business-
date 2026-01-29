import { Campaign } from "@/model/campaign.model";
import { CampaignCreative, CampaignItem } from "@/model/campaign-item.model";
import { AdSlotModel } from "@/model/ad-slot.model";
import { isCampaignItemReady } from "@/utils/campaign-validation";
import { generateReference } from "@/utils/utils";

const STORAGE_KEY = "brantr0_campaign_draft";
export const CAMPAIGN_UPDATED_EVENT = "campaign-updated";

const previewUrlCache = new Map<string, string>();

const emptyCampaign: Campaign = {
  reference: undefined,
  items: [],
  currency: "NGN",
  subtotal: "0",
  total: "0",
  status: "DRAFT",
};

const safeNumber = (v: any) => {
  const n = Number(v);
  return Number.isFinite(n) ? n : 0;
};

const calculateItemSubtotal = (unitPrice: string, quantity: number) =>
  String(safeNumber(unitPrice) * safeNumber(quantity));

const syncItemStatus = (item: CampaignItem): CampaignItem => ({
  ...item,
  status: isCampaignItemReady(item) ? "READY" : "INCOMPLETE",
});

const calculateTotals = (items: CampaignItem[]) => {
  const subtotal = items.reduce((sum, i) => sum + safeNumber(i.subtotal), 0);
  return { subtotal: String(subtotal), total: String(subtotal) };
};

const ensureReference = (campaign: Campaign) => {
  if (!campaign.reference) {
    campaign.reference = generateReference('CMPN');
  }
};

const saveCampaign = (campaign: Campaign) => {
  if (typeof window === "undefined") return;
  ensureReference(campaign);
  localStorage.setItem(STORAGE_KEY, JSON.stringify(campaign));
  window.dispatchEvent(new Event(CAMPAIGN_UPDATED_EVENT));
};

export const getCampaign = (): Campaign => {
  if (typeof window === "undefined") return emptyCampaign;

  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return emptyCampaign;

    const parsed = JSON.parse(raw);
    const items = Array.isArray(parsed.items)
      ? parsed.items.map(syncItemStatus)
      : [];

    const totals = calculateTotals(items);

    const campaign: Campaign = {
      ...emptyCampaign,
      ...parsed,
      items,
      subtotal: totals.subtotal,
      total: totals.total,
    };

    ensureReference(campaign);
    return campaign;
  } catch {
    return emptyCampaign;
  }
};

export const clearCampaign = async () => {
  if (typeof window === "undefined") return;

  const { removeFile } = await import("@/utils/db/local-file.db");
  const campaign = getCampaign();

  for (const item of campaign.items) {
    for (const c of item.creatives || []) {
      const url = previewUrlCache.get(c.id);
      if (url) URL.revokeObjectURL(url);
      previewUrlCache.delete(c.id);
      await removeFile(c.id);
    }
  }

  localStorage.removeItem(STORAGE_KEY);
  window.dispatchEvent(new Event(CAMPAIGN_UPDATED_EVENT));
};

export const addAdSlotToCampaign = (adSlot: AdSlotModel) => {
  const campaign = getCampaign();
  if (campaign.items.some((i) => i.adSlotId === adSlot.id)) return campaign;

  const unitPrice = String(adSlot.price ?? 0);

  campaign.items.push(
    syncItemStatus({
      id: crypto.randomUUID(),
      adSlotId: adSlot.id,
      adSlot,
      quantity: 1,
      creatives: [],
      unitPrice,
      subtotal: unitPrice,
      status: "INCOMPLETE",
    }),
  );

  const totals = calculateTotals(campaign.items);
  campaign.subtotal = totals.subtotal;
  campaign.total = totals.total;

  saveCampaign(campaign);
  return campaign;
};

export const updateCampaignItemQuantity = (
  itemId: string,
  quantity: number,
) => {
  const q = Math.max(1, safeNumber(quantity));
  const campaign = getCampaign();

  campaign.items = campaign.items.map((i) =>
    i.id === itemId
      ? syncItemStatus({
          ...i,
          quantity: q,
          subtotal: calculateItemSubtotal(i.unitPrice, q),
        })
      : i,
  );

  const totals = calculateTotals(campaign.items);
  campaign.subtotal = totals.subtotal;
  campaign.total = totals.total;

  saveCampaign(campaign);
};

export const attachCreativesToCampaignItem = async (
  itemId: string,
  files: File[],
) => {
  if (!files?.length) return;
  const campaign = getCampaign();
  const { saveFile } = await import("@/utils/db/local-file.db");

  campaign.items = await Promise.all(
    campaign.items.map(async (item) => {
      if (item.id !== itemId) return item;

      const newCreatives: CampaignCreative[] = [];

      for (const file of files) {
        const id = crypto.randomUUID();

        await saveFile({
          id,
          blob: file,
          mimeType: file.type,
          name: file.name,
        });

        newCreatives.push({
          id,
          name: file.name,
          mimeType: file.type,
          size: file.size,
          description: "",
          status: "PENDING",
        });
      }

      return syncItemStatus({
        ...item,
        creatives: [...item.creatives, ...newCreatives],
      });
    }),
  );

  const totals = calculateTotals(campaign.items);
  campaign.subtotal = totals.subtotal;
  campaign.total = totals.total;

  saveCampaign(campaign);
};

export const hydrateCampaignCreatives = async (campaign: Campaign) => {
  if (typeof window === "undefined") return campaign;

  const { getFile } = await import("@/utils/db/local-file.db");

  await Promise.all(
    campaign.items.map(async (item) => {
      await Promise.all(
        (item.creatives || []).map(async (c) => {
          if (previewUrlCache.has(c.id)) {
            c.previewUrl = previewUrlCache.get(c.id)!;
            return;
          }

          const stored = await getFile(c.id);
          if (!stored?.blob) return;

          const file = new File([stored.blob], stored.name, {
            type: stored.mimeType,
          });

          const url = URL.createObjectURL(file);
          previewUrlCache.set(c.id, url);

          c.file = file;
          c.previewUrl = url;
        }),
      );
    }),
  );

  return campaign;
};

export const removeCreativeFromItem = (itemId, creativeId) => {
  const campaign = getCampaign();

  campaign.items = campaign.items.map((item) => {
    if (String(item.id) !== String(itemId)) return item;

    return {
      ...item,
      creatives: (item.creatives || []).filter(
        (c) => String(c.id) !== String(creativeId),
      ),
    };
  });

  saveCampaign(campaign);
  return campaign;
};

export const updateCreativeDescription = (itemId, creativeId, description) => {
  const campaign = getCampaign();

  campaign.items = campaign.items.map((item) => {
    if (String(item.id) !== String(itemId)) return item;

    return {
      ...item,
      creatives: (item.creatives || []).map((creative) =>
        String(creative.id) === String(creativeId)
          ? { ...creative, description }
          : creative,
      ),
    };
  });

  saveCampaign(campaign);
  return campaign;
};

export const removeCampaignItem = (itemId) => {
  const campaign = getCampaign();

  campaign.items = campaign.items.filter(
    (item) => String(item.id) !== String(itemId),
  );

  saveCampaign(campaign);
  return campaign;
};

export const getDraftCampaignCount = (): number => {
  if (typeof window === "undefined") return 0;
  try {
    return getCampaign().items?.length || 0;
  } catch {
    return 0;
  }
};
