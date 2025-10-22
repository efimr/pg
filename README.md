A PostgreSQL function that parses a URL and returns the parsed result in JSONB format.

To publish the function, you can use the standard "public" data schema, or you can register functions in any other schema.

Simply pass a JSONB object with the "full_url" property.

<h2>Example query:</h2>

```sql
select public.url_parser('{"full_url": "https://www.example.com/path/to/resource?query=value#fragment"}'::jsonb);
```

<h2>Output format</h2>

The output is a JSONB object of the following format:
```json
{
  "info": "Performed URI parsing;",
  "full_url": "https://www.example.com/path/to/resource?query=value#fragment",
  "uri_path": "/path/to/resource",
  "uri_query": "query=value",
  "uri_scheme": "https",
  "uri_fragment": "fragment",
  "iana_rootzone": "com",
  "uri_authority": "www.example.com",
  "uri_components": [
    "https:",
    "https",
    "//www.example.com",
    "www.example.com",
    "/path/to/resource",
    "?query=value",
    "query=value",
    "#fragment",
    "fragment"
  ],
  "full_url_length": 61,
  "domain_name_level": 3,
  "uri_scheme_default_port": 443
}
```

<h2>The "info" key</h2>
Information about the parsing process. This information may be positive if valid data is passed. It may also be negative if some of the data contradicts the intended purpose of the URL.

<h2>The "full_url" key</h2>
The most important property in the incoming object. It must be in the form of a standard URL.
Don't pass "null," "number," or "boolean." Use a classic JavaScript string, enclosed in double quotes, according to the JSON standard.

<h2>The "uri_scheme" key</h2>
The first element of the URI syntax, from left to right. Defines the "uniform resource identifier" scheme.
When parsing a URL, we get either "http" or "https." This affects the standard port numbers that browsers hide in the address bar.
