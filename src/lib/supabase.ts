import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Missing Supabase environment variables')
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

// Types
export interface Product {
  id: string
  name: string
  slug: string
  description: string
  short_description: string
  sku: string
  category_id: string
  brand: string
  images: string[]
  base_price: number
  wholesale_price: number
  stock_quantity: number
  min_order_quantity: number
  weight: number
  dimensions: any
  is_active: boolean
  is_featured: boolean
  kara_product_id?: string
  created_at: string
  updated_at: string
}

export interface Category {
  id: string
  name: string
  slug: string
  description: string
  image_url?: string
  parent_id?: string
  sort_order: number
  is_active: boolean
  created_at: string
}

export interface CartItem {
  id: string
  user_id: string
  product_id: string
  quantity: number
  created_at: string
  updated_at: string
  product?: Product
}

export interface Order {
  id: string
  user_id: string
  order_number: string
  status: string
  order_type: string
  total_amount: number
  discount_amount: number
  shipping_cost: number
  payment_method: string
  payment_status: string
  shipping_address: any
  billing_address: any
  notes?: string
  kara_order_id?: string
  created_at: string
  updated_at: string
}

export interface Profile {
  id: string
  user_id: string
  full_name: string
  phone: string
  address: string
  business_type: string
  is_wholesale_customer: boolean
  created_at: string
  updated_at: string
}