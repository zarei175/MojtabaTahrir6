-- Create storage bucket for product images
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'mojtaba_tahrir_images_2025_01_05_21_00',
  'mojtaba_tahrir_images_2025_01_05_21_00',
  true,
  52428800, -- 50MB limit
  ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif']
)
ON CONFLICT (id) DO NOTHING;

-- Create storage policies for the bucket
CREATE POLICY "Public Access for Images"
ON storage.objects FOR SELECT
USING (bucket_id = 'mojtaba_tahrir_images_2025_01_05_21_00');

CREATE POLICY "Authenticated users can upload images"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'mojtaba_tahrir_images_2025_01_05_21_00' 
  AND auth.uid() IS NOT NULL
);

CREATE POLICY "Users can update their own images"
ON storage.objects FOR UPDATE
USING (
  bucket_id = 'mojtaba_tahrir_images_2025_01_05_21_00' 
  AND auth.uid() IS NOT NULL
);

CREATE POLICY "Users can delete their own images"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'mojtaba_tahrir_images_2025_01_05_21_00' 
  AND auth.uid() IS NOT NULL
);