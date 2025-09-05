-- Create price requests table
CREATE TABLE public.mojtaba_tahrir_price_requests_2025_01_05_21_00 (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  products JSONB NOT NULL,
  message TEXT,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'quoted', 'accepted', 'rejected')),
  quoted_price DECIMAL(10,2),
  admin_notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable RLS on price requests
ALTER TABLE public.mojtaba_tahrir_price_requests_2025_01_05_21_00 ENABLE ROW LEVEL SECURITY;

-- Create policies for price requests
CREATE POLICY "Users can view their own price requests" 
ON public.mojtaba_tahrir_price_requests_2025_01_05_21_00 
FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own price requests" 
ON public.mojtaba_tahrir_price_requests_2025_01_05_21_00 
FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own price requests" 
ON public.mojtaba_tahrir_price_requests_2025_01_05_21_00 
FOR UPDATE 
USING (auth.uid() = user_id);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_price_requests_updated_at
BEFORE UPDATE ON public.mojtaba_tahrir_price_requests_2025_01_05_21_00
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();