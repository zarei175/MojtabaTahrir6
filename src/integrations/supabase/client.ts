import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://xpcfccyajjgjikqrxjya.supabase.co'
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhwY2ZjY3lhampnamlrcXJ4anlhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcxMDM3NDUsImV4cCI6MjA3MjY3OTc0NX0.TJe-bpCFr6QhS_gjWozWgEVUraSWroufnZ0_FIw0ZfY'

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    storage: localStorage,
    persistSession: true,
    autoRefreshToken: true,
    detectSessionInUrl: true
  }
});

// Import the supabase client like this:
// import { supabase } from "@/integrations/supabase/client";
