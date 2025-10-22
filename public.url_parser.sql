CREATE OR REPLACE FUNCTION public.url_parser(in_obj jsonb)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
/*
  2025-10-22 22:00 - v6 !!! feature under development !!!

  select public.url_parser(null::jsonb);
  select public.url_parser('null'::jsonb);
  select public.url_parser('{}'::jsonb);
  select public.url_parser('{"full_url": null}'::jsonb);
  select public.url_parser('{"full_url": ""}'::jsonb);
  select public.url_parser('{"full_url": "https://www.example.com/path/to/resource?query=value#fragment"}'::jsonb);

  select regexp_match('https://www.example.com/path/to/resource?query=value#fragment', '^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?');
*/
declare
  x_info text := '';
  --x_key_prefix text := '';

  -- https://datatracker.ietf.org/doc/html/rfc3986#appendix-B
  x_uri_jb jsonb;
  x_uri_components text[];
  x_uri_regexp text := '^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?';
  x_uri_scheme text; --$2
  x_uri_authority text; --$4
  x_uri_path text; --$5
  x_uri_query text; --$7
  x_uri_fragment text; --$9

  x_uri_scheme_default_port int;

  x_full_url text;
  x_result jsonb := '{}'::jsonb;
begin

  /* checking the existence of an input parameter */
  /* проверка существования входящего параметра */
  if in_obj is null or in_obj = 'null'::jsonb or in_obj = x_result then
    x_info := 'Error - input parameter is not defined;'; /* Ошибка - входящий параметр не определён */
    x_result := jsonb_build_object( 'info', x_info );
    return x_result;
  end if;

  x_full_url := (in_obj ->> 'full_url')::text;

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

  x_uri_components := regexp_match(x_full_url, x_uri_regexp);
  x_uri_scheme := x_uri_components[2]; --$2
  x_uri_authority := x_uri_components[4]; --$4
  x_uri_path := x_uri_components[5]; --$5
  x_uri_query := x_uri_components[7]; --$7
  x_uri_fragment := x_uri_components[9]; --$9

  x_info := x_info || 'Performed URI parsing;'; /* Выполнили синтаксический анализ URI */

  if x_uri_scheme = 'https' then
    x_uri_scheme_default_port := 443;
  elseif x_uri_scheme = 'http' then
    x_uri_scheme_default_port := 80;
  end if;

  x_uri_jb := jsonb_build_object(
    'uri_components', x_uri_components,
    'uri_scheme', x_uri_scheme,
    'uri_authority', x_uri_authority,
    'uri_path', x_uri_path,
    'uri_query', x_uri_query,
    'uri_fragment', x_uri_fragment,
    'uri_scheme_default_port', x_uri_scheme_default_port,
    'info', x_info
  );

  x_result := x_uri_jb;

  /* we supplement the incoming object with parameters */
  /* дополняем входящий объект параметрами */
  x_result := in_obj || x_result;
  return x_result;
end;
$function$
;
