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
  "info": "Performed URI parsing",
  "full_url": "https://www.example.com/path/to/resource?query=value#fragment",
  "uri_path": "/path/to/resource",
  "uri_query": "query=value",
  "uri_scheme": "https",
  "uri_fragment": "fragment",
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
  ]
}
```

<h2>The "info" key</h2>
Information about the parsing process. This information may be positive if valid data is passed. It may also be negative if some of the data contradicts the intended purpose of the URL.
