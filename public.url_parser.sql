CREATE OR REPLACE FUNCTION public.url_parser(in_obj jsonb)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
-- 2025-10-19 14:00 - v4
-- !!! feature under development !!!
-- select public.url_parser(null::jsonb)
-- select public.url_parser('null'::jsonb)
-- select public.url_parser('{}'::jsonb)
-- select public.url_parser('{"full_url": null}'::jsonb)
-- select public.url_parser('{"full_url": ""}'::jsonb)
declare
  x_info text := '';
  x_full_url text;
  x_result jsonb := '{}'::jsonb;
begin
  x_full_url := (in_obj ->> 'full_url')::text;

  /* checking the existence of an input parameter */
  /* проверка существования входящего параметра */
  if in_obj is null or in_obj = 'null'::jsonb or in_obj = x_result then
    x_info := 'Error - input parameter is not defined;'; /* Ошибка - входящий параметр не определён */
    x_result := jsonb_build_object( 'info', x_info );
    return x_result;
  end if;
  
  if x_full_url is null then
    x_info := 'Unable to parse the address - not found;'; /* Невозможно разобрать адрес - не обнаружен */
    x_result := jsonb_build_object( 'info', x_info );
    return x_result;
  end if;

  if x_full_url = '' then
    x_info := 'Unable to parse the address - empty string;'; /* Невозможно разобрать адрес - пустая строка */
    x_result := jsonb_build_object( 'info', x_info );
    return x_result;
  end if;

  /* we supplement the incoming object with parameters */
  /* дополняем входящий объект параметрами */
  x_result := in_obj || x_result;
  return x_result;
end;
$function$
;
