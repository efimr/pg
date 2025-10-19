CREATE OR REPLACE FUNCTION public.url_parser(in_obj jsonb)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
-- 2025-10-19 13:00 - v3
-- !!! feature under development !!!
-- select public.url_parser(null::jsonb)
-- select public.url_parser('{}'::jsonb)
-- select public.url_parser('{"full_url": null}'::jsonb)
-- select public.url_parser('{"full_url": ""}'::jsonb)
declare
  x_info text := '';
  x_full_url text;
  x_result jsonb := '{}'::jsonb;
begin
  x_full_url := (in_obj ->> 'full_url')::text;
  
  if x_full_url is null or x_full_url = '' then
    x_info := 'unable to parse address;';
    x_result := jsonb_build_object( 'info', x_info );
  end if;

  /* we supplement the incoming object with parameters */
  x_result := in_obj || x_result;
  return x_result;
end;
$function$
;
