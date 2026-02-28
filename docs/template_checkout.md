import { generateReference, safeNumber } from "@/utils/utils";
import { Template } from "@/model/template.model";

const STORAGE_KEY = "brantr0_template_cart";

/* ===============================
 * Types
 * =============================== */
export interface TemplateCartItem {
  id: number;
  reference: string;
  title: string;
  category?: any;
  thumbnail?: string | null;
  fileUrl: string;
  formats: string[];
  price: number;
  discount: number;
}

export interface TemplateCart {
  reference?: string;
  items: TemplateCartItem[];
  currency: "NGN";
  subtotal: number;
  total: number;
}

/* ===============================
 * Defaults
 * =============================== */
const emptyCart: TemplateCart = {
  reference: undefined,
  items: [],
  currency: "NGN",
  subtotal: 0,
  total: 0,
};

/* ===============================
 * Helpers
 * =============================== */
const ensureReference = (cart: TemplateCart) => {
  if (!cart.reference) {
    cart.reference = generateReference('TPL');
  }
};

const calculateTotals = (items: TemplateCartItem[]) => {
  const subtotal = items.reduce(
    (sum, i) => sum + Math.max(i.price - i.discount, 0),
    0,
  );

  return { subtotal, total: subtotal };
};

const saveCart = (cart: TemplateCart) => {
  if (typeof window === "undefined") return;
  ensureReference(cart);
  localStorage.setItem(STORAGE_KEY, JSON.stringify(cart));
  window.dispatchEvent(new Event("template-cart-updated"));
};

/* ===============================
 * Read / Clear
 * =============================== */
export const getTemplateCart = (): TemplateCart => {
  if (typeof window === "undefined") return emptyCart;

  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return emptyCart;

    const parsed = JSON.parse(raw);
    const items: TemplateCartItem[] = Array.isArray(parsed.items)
      ? parsed.items
      : [];

    const totals = calculateTotals(items);

    const cart: TemplateCart = {
      ...emptyCart,
      ...parsed,
      items,
      subtotal: totals.subtotal,
      total: totals.total,
    };

    ensureReference(cart);
    return cart;
  } catch {
    return emptyCart;
  }
};

export const clearTemplateCart = () => {
  if (typeof window === "undefined") return;
  localStorage.removeItem(STORAGE_KEY);
  window.dispatchEvent(new Event("template-cart-updated"));
};

/* ===============================
 * Mutations
 * =============================== */
export const addTemplateToCart = (template: Template): TemplateCart => {
  const cart = getTemplateCart();

  if (cart.items.some((i) => i.id === template.id)) {
    return cart;
  }

  const item: TemplateCartItem = {
    id: safeNumber(template.id),
    reference: generateReference(),
    title: template.title || "",
    category: template.category,
    thumbnail: template.thumbnail || null,
    fileUrl: template.fileUrl,
    formats: template.type ? [template.type] : [],
    price: safeNumber(template.price),
    discount: safeNumber(template.discount),
  };

  const items = [...cart.items, item];
  const totals = calculateTotals(items);

  const updated: TemplateCart = {
    ...cart,
    items,
    subtotal: totals.subtotal,
    total: totals.total,
  };

  saveCart(updated);
  return updated;
};

export const removeTemplateFromCart = (id: number) => {
  const cart = getTemplateCart();

  const items = cart.items.filter((i) => i.id !== safeNumber(id));
  const totals = calculateTotals(items);

  const updated: TemplateCart = {
    ...cart,
    items,
    subtotal: totals.subtotal,
    total: totals.total,
  };

  saveCart(updated);
};