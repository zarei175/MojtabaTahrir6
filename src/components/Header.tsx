import React from 'react'
import { ShoppingCart, User, Search, Menu, Phone, Mail } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Badge } from '@/components/ui/badge'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import { useAuth } from '@/contexts/AuthContext'
import { useCart } from '@/contexts/CartContext'
import { Link } from 'react-router-dom'

export const Header: React.FC = () => {
  const { user, signOut } = useAuth()
  const { getTotalItems } = useCart()

  return (
    <header className="bg-white shadow-sm border-b">
      {/* Top Bar */}
      <div className="bg-primary text-primary-foreground py-2">
        <div className="container mx-auto px-4">
          <div className="flex justify-between items-center text-sm">
            <div className="flex items-center gap-4">
              <div className="flex items-center gap-2">
                <Phone className="w-4 h-4" />
                <span>021-88776655</span>
              </div>
              <div className="flex items-center gap-2">
                <Mail className="w-4 h-4" />
                <span>info@mojtabatahrir.com</span>
              </div>
            </div>
            <div className="text-sm">
              فروش عمده لوازم التحریر با بهترین قیمت
            </div>
          </div>
        </div>
      </div>

      {/* Main Header */}
      <div className="container mx-auto px-4 py-4">
        <div className="flex items-center justify-between">
          {/* Logo */}
          <Link to="/" className="flex items-center gap-3">
            <div className="w-12 h-12 bg-gradient-to-r from-primary to-primary-glow rounded-lg flex items-center justify-center">
              <span className="text-white font-bold text-xl">م</span>
            </div>
            <div>
              <h1 className="text-2xl font-bold text-gradient">مجتبی تحریر</h1>
              <p className="text-sm text-muted-foreground">فروشگاه آنلاین لوازم التحریر</p>
            </div>
          </Link>

          {/* Search Bar */}
          <div className="flex-1 max-w-md mx-8">
            <div className="relative">
              <Search className="absolute right-3 top-1/2 transform -translate-y-1/2 text-muted-foreground w-4 h-4" />
              <Input
                placeholder="جستجوی محصولات..."
                className="pr-10"
              />
            </div>
          </div>

          {/* Actions */}
          <div className="flex items-center gap-4">
            {/* Cart */}
            <Link to="/cart">
              <Button variant="outline" size="sm" className="relative">
                <ShoppingCart className="w-4 h-4 ml-2" />
                سبد خرید
                {getTotalItems() > 0 && (
                  <Badge className="absolute -top-2 -right-2 bg-primary text-primary-foreground">
                    {getTotalItems()}
                  </Badge>
                )}
              </Button>
            </Link>

            {/* User Menu */}
            {user ? (
              <DropdownMenu>
                <DropdownMenuTrigger asChild>
                  <Button variant="outline" size="sm">
                    <User className="w-4 h-4 ml-2" />
                    حساب کاربری
                  </Button>
                </DropdownMenuTrigger>
                <DropdownMenuContent align="end" className="w-48">
                  <DropdownMenuItem asChild>
                    <Link to="/profile">پروفایل</Link>
                  </DropdownMenuItem>
                  <DropdownMenuItem asChild>
                    <Link to="/orders">سفارش‌های من</Link>
                  </DropdownMenuItem>
                  <DropdownMenuItem asChild>
                    <Link to="/price-requests">درخواست قیمت</Link>
                  </DropdownMenuItem>
                  <DropdownMenuSeparator />
                  <DropdownMenuItem onClick={signOut}>
                    خروج
                  </DropdownMenuItem>
                </DropdownMenuContent>
              </DropdownMenu>
            ) : (
              <div className="flex gap-2">
                <Link to="/login">
                  <Button variant="outline" size="sm">
                    ورود
                  </Button>
                </Link>
                <Link to="/register">
                  <Button size="sm" className="btn-premium">
                    ثبت نام
                  </Button>
                </Link>
              </div>
            )}

            {/* Mobile Menu */}
            <Button variant="outline" size="sm" className="md:hidden">
              <Menu className="w-4 h-4" />
            </Button>
          </div>
        </div>
      </div>

      {/* Navigation */}
      <nav className="bg-gray-50 border-t">
        <div className="container mx-auto px-4">
          <div className="flex items-center gap-8 py-3">
            <Link to="/" className="text-sm font-medium hover:text-primary transition-colors">
              صفحه اصلی
            </Link>
            <Link to="/products" className="text-sm font-medium hover:text-primary transition-colors">
              محصولات
            </Link>
            <Link to="/categories" className="text-sm font-medium hover:text-primary transition-colors">
              دسته‌بندی‌ها
            </Link>
            <Link to="/wholesale" className="text-sm font-medium hover:text-primary transition-colors">
              فروش عمده
            </Link>
            <Link to="/brands" className="text-sm font-medium hover:text-primary transition-colors">
              برندها
            </Link>
            <Link to="/contact" className="text-sm font-medium hover:text-primary transition-colors">
              تماس با ما
            </Link>
          </div>
        </div>
      </nav>
    </header>
  )
}