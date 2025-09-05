import React, { createContext, useContext, useEffect, useState } from 'react'
import { CartItem, Product } from '@/lib/supabase'
import { supabase } from '@/lib/supabase'
import { useAuth } from './AuthContext'
import { toast } from '@/hooks/use-toast'

interface CartContextType {
  items: CartItem[]
  loading: boolean
  addToCart: (productId: string, quantity: number) => Promise<void>
  updateQuantity: (itemId: string, quantity: number) => Promise<void>
  removeFromCart: (itemId: string) => Promise<void>
  clearCart: () => Promise<void>
  getTotalPrice: () => number
  getTotalItems: () => number
}

const CartContext = createContext<CartContextType | undefined>(undefined)

export const useCart = () => {
  const context = useContext(CartContext)
  if (context === undefined) {
    throw new Error('useCart must be used within a CartProvider')
  }
  return context
}

export const CartProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [items, setItems] = useState<CartItem[]>([])
  const [loading, setLoading] = useState(false)
  const { user } = useAuth()

  useEffect(() => {
    if (user) {
      fetchCartItems()
    } else {
      setItems([])
    }
  }, [user])

  const fetchCartItems = async () => {
    if (!user) return

    try {
      setLoading(true)
      const { data, error } = await supabase
        .from('mojtaba_tahrir_cart_items_2025_01_05_21_00')
        .select(`
          *,
          product:mojtaba_tahrir_products_2025_01_05_21_00(*)
        `)
        .eq('user_id', user.id)

      if (error) throw error
      setItems(data || [])
    } catch (error: any) {
      toast({
        title: "خطا در بارگیری سبد خرید",
        description: error.message,
        variant: "destructive",
      })
    } finally {
      setLoading(false)
    }
  }

  const addToCart = async (productId: string, quantity: number) => {
    if (!user) {
      toast({
        title: "لطفاً وارد شوید",
        description: "برای افزودن به سبد خرید باید وارد حساب کاربری خود شوید",
        variant: "destructive",
      })
      return
    }

    try {
      // Check if item already exists
      const existingItem = items.find(item => item.product_id === productId)
      
      if (existingItem) {
        await updateQuantity(existingItem.id, existingItem.quantity + quantity)
      } else {
        const { data, error } = await supabase
          .from('mojtaba_tahrir_cart_items_2025_01_05_21_00')
          .insert({
            user_id: user.id,
            product_id: productId,
            quantity
          })
          .select(`
            *,
            product:mojtaba_tahrir_products_2025_01_05_21_00(*)
          `)
          .single()

        if (error) throw error
        
        setItems(prev => [...prev, data])
        toast({
          title: "محصول به سبد خرید اضافه شد",
          description: "محصول با موفقیت به سبد خرید شما اضافه شد",
        })
      }
    } catch (error: any) {
      toast({
        title: "خطا در افزودن به سبد خرید",
        description: error.message,
        variant: "destructive",
      })
    }
  }

  const updateQuantity = async (itemId: string, quantity: number) => {
    if (quantity <= 0) {
      await removeFromCart(itemId)
      return
    }

    try {
      const { data, error } = await supabase
        .from('mojtaba_tahrir_cart_items_2025_01_05_21_00')
        .update({ quantity })
        .eq('id', itemId)
        .select(`
          *,
          product:mojtaba_tahrir_products_2025_01_05_21_00(*)
        `)
        .single()

      if (error) throw error

      setItems(prev => prev.map(item => 
        item.id === itemId ? data : item
      ))
    } catch (error: any) {
      toast({
        title: "خطا در بروزرسانی سبد خرید",
        description: error.message,
        variant: "destructive",
      })
    }
  }

  const removeFromCart = async (itemId: string) => {
    try {
      const { error } = await supabase
        .from('mojtaba_tahrir_cart_items_2025_01_05_21_00')
        .delete()
        .eq('id', itemId)

      if (error) throw error

      setItems(prev => prev.filter(item => item.id !== itemId))
      toast({
        title: "محصول حذف شد",
        description: "محصول از سبد خرید حذف شد",
      })
    } catch (error: any) {
      toast({
        title: "خطا در حذف محصول",
        description: error.message,
        variant: "destructive",
      })
    }
  }

  const clearCart = async () => {
    if (!user) return

    try {
      const { error } = await supabase
        .from('mojtaba_tahrir_cart_items_2025_01_05_21_00')
        .delete()
        .eq('user_id', user.id)

      if (error) throw error

      setItems([])
      toast({
        title: "سبد خرید خالی شد",
        description: "تمام محصولات از سبد خرید حذف شدند",
      })
    } catch (error: any) {
      toast({
        title: "خطا در خالی کردن سبد خرید",
        description: error.message,
        variant: "destructive",
      })
    }
  }

  const getTotalPrice = () => {
    return items.reduce((total, item) => {
      const price = item.product?.wholesale_price || item.product?.base_price || 0
      return total + (price * item.quantity)
    }, 0)
  }

  const getTotalItems = () => {
    return items.reduce((total, item) => total + item.quantity, 0)
  }

  const value = {
    items,
    loading,
    addToCart,
    updateQuantity,
    removeFromCart,
    clearCart,
    getTotalPrice,
    getTotalItems,
  }

  return <CartContext.Provider value={value}>{children}</CartContext.Provider>
}