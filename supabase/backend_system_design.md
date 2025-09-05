# طراحی سیستم بک‌اند فروشگاه مجتبی تحریر

## جداول پایگاه داده

### Table: mojtaba_tahrir_profiles_2025_01_05_21_00
- id: uuid (primary key)
- user_id: uuid (foreign key to auth.users)
- full_name: text
- phone: text
- address: text
- business_type: text (individual, wholesale, retail)
- is_wholesale_customer: boolean (default: false)
- created_at: timestamp
- updated_at: timestamp

### Table: mojtaba_tahrir_categories_2025_01_05_21_00
- id: uuid (primary key)
- name: text
- slug: text (unique)
- description: text
- image_url: text
- parent_id: uuid (self-reference for subcategories)
- sort_order: integer
- is_active: boolean (default: true)
- created_at: timestamp

### Table: mojtaba_tahrir_products_2025_01_05_21_00
- id: uuid (primary key)
- name: text
- slug: text (unique)
- description: text
- short_description: text
- sku: text (unique)
- category_id: uuid (foreign key)
- brand: text
- images: jsonb (array of image URLs)
- base_price: decimal
- wholesale_price: decimal
- stock_quantity: integer
- min_order_quantity: integer (default: 1)
- weight: decimal
- dimensions: jsonb
- is_active: boolean (default: true)
- is_featured: boolean (default: false)
- kara_product_id: text (for sync with Kara software)
- created_at: timestamp
- updated_at: timestamp

### Table: mojtaba_tahrir_bulk_pricing_2025_01_05_21_00
- id: uuid (primary key)
- product_id: uuid (foreign key)
- min_quantity: integer
- max_quantity: integer
- price: decimal
- discount_percentage: decimal
- created_at: timestamp

### Table: mojtaba_tahrir_orders_2025_01_05_21_00
- id: uuid (primary key)
- user_id: uuid (foreign key)
- order_number: text (unique)
- status: text (pending, confirmed, processing, shipped, delivered, cancelled)
- order_type: text (wholesale, retail)
- total_amount: decimal
- discount_amount: decimal
- shipping_cost: decimal
- payment_method: text
- payment_status: text
- shipping_address: jsonb
- billing_address: jsonb
- notes: text
- kara_order_id: text (for sync with Kara software)
- created_at: timestamp
- updated_at: timestamp

### Table: mojtaba_tahrir_order_items_2025_01_05_21_00
- id: uuid (primary key)
- order_id: uuid (foreign key)
- product_id: uuid (foreign key)
- quantity: integer
- unit_price: decimal
- total_price: decimal
- created_at: timestamp

### Table: mojtaba_tahrir_price_requests_2025_01_05_21_00
- id: uuid (primary key)
- user_id: uuid (foreign key)
- products: jsonb (array of {product_id, quantity})
- message: text
- status: text (pending, quoted, accepted, rejected)
- quoted_price: decimal
- admin_notes: text
- created_at: timestamp
- updated_at: timestamp

### Table: mojtaba_tahrir_cart_items_2025_01_05_21_00
- id: uuid (primary key)
- user_id: uuid (foreign key)
- product_id: uuid (foreign key)
- quantity: integer
- created_at: timestamp
- updated_at: timestamp

## Edge Functions

### Edge Function: sync_with_kara_2025_01_05_21_00
- description: همگام‌سازی محصولات و سفارش‌ها با نرم‌افزار کارا
- params: {action: string, data: object}
- return value: {success: boolean, message: string, data: object}

### Edge Function: calculate_bulk_price_2025_01_05_21_00
- description: محاسبه قیمت بر اساس تعداد خرید
- params: {product_id: string, quantity: number}
- return value: {unit_price: number, total_price: number, discount_percentage: number}

### Edge Function: process_order_2025_01_05_21_00
- description: پردازش سفارش و ارسال به کارا
- params: {order_data: object}
- return value: {success: boolean, order_id: string, kara_order_id: string}

### Edge Function: get_product_availability_2025_01_05_21_00
- description: بررسی موجودی محصول از کارا
- params: {product_id: string}
- return value: {available: boolean, stock_quantity: number, price: number}

## File Storage Bucket

### File Storage Bucket: mojtaba_tahrir_images_2025_01_05_21_00
- public: true
- برای ذخیره تصاویر محصولات، دسته‌بندی‌ها و سایر فایل‌های تصویری

## RLS Policies

- تمام جداول دارای سیاست‌های RLS مناسب برای کنترل دسترسی
- کاربران عادی فقط به داده‌های خود دسترسی دارند
- ادمین‌ها به تمام داده‌ها دسترسی دارند
- محصولات و دسته‌بندی‌ها برای همه قابل مشاهده هستند

## Authentication

- استفاده از سیستم احراز هویت Supabase
- ثبت نام با ایمیل و رمز عبور
- تأیید ایمیل الزامی
- امکان ورود با شماره تلفن (اختیاری)