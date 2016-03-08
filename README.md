# Ruby Filterparams #

Filterparams is a library for specifying filters through a REST API
on collection resources on top of HTTP. It provides the capability
to specify SQL-like syntax on top of query parameters.

Due to it's intended use of building [JSONAPI](http://jsonapi.org/)
libraries with this definition, it is compatible with the definition
and encapsulates it's syntax through the prefixed `filter` parameters.

## Installation ##

The library is available through the `filterparams` gemfile and thus
can be installed through the command line or by adding the package to
your Gemfile.

```
gem install filterparams
```

## Example ##

Given the URL (non URL escaped for better readability):

```
/users?filter[param][name][like][no_brand_name]=doe&filter[param][first_name]=doe%&filter[binding]=(!no_brand_name&first_name)&filter[order]=name&filter[order]=desc(first_name)
```

It can be parsed with the following code:

```ruby
require 'uri'
require 'cgi'
require 'filterparams'

url = 'http://www.example.com/users?' +
      'filter[param][name][like][no_brand_name]=doe' +
      '&filter[param][first_name]=doe%' +
      '&filter[binding]=%28%21no_brand_name%26first_name%29' +
      '&filter[order]=name&filter[order]=desc(first_name)'

data = CGI.parse(URI.parse(url).query)

Filterparams::extract_query(data)
```

This would result into a query instance being produced with the
following data:

```
#<Filterparams::Query:0x007ff78b1a51c8
 @filters=
  #<Filterparams::And:0x007ff78b1a57e0
   @left=
    #<Filterparams::Not:0x007ff78b1a6ed8
     @inner=
      #<Filterparams::Parameter:0x007ff78b1ee940
       @alias="no_brand_name",
       @filter="like",
       @name="name",
       @value="doe">>,
   @right=
    #<Filterparams::Parameter:0x007ff78b1ee918
     @alias=nil,
     @filter=nil,
     @name="first_name",
     @value="doe%">>,
 @orders=
  [#<Filterparams::Order:0x007ff78b1ee5f8 @direction="asc", @name="name">,
   #<Filterparams::Order:0x007ff78b1ee3a0
    @direction="desc",
    @name="first_name">]>
```

The orders can be accessed through the `.orders` method and the filter
binding through `.filters`.

## Syntax ##

All arguments must be prefixed by "filter". It is possible to
query for specific data with filters, apply orders to the result
and to combine filters through AND, NOT and OR bindings.

The syntax builds under the filter parameter a virtual object.
The keys of the object are simulated through specifying `[{key}]`
in the passed query parameter. Thus `filter[param]` would point
to the param key in the filter object.

### Filter specification ###

The solution supports to query data through the `param` subkey.

```
filter[param][{parameter_name}][{operation}][{alias}] = {to_query_value}
```

The `operation` and `alias` parameters may be omitted. If no
`alias` is provided the given parameter name is used for it.
If no `operation` is given, the default one is used (in the
example this would be equal).

Example:
```
filter[param][phone_number][like]=001%
```

This would add a filter to all phone numbers which start with "001".

### Filter binding ###

Per default all filters are combined through AND clauses.
You can change that by specifying the `filter[binding]` argument.

This is where the aliases which you can define come into place.
The binding provides means to combine filters with AND and OR.
Also you are able to negate filters here.

The filters are addressed by their alias or name, if no alias is
provided.

If you have a filter `search_for_name`, `search_for_phone_number`
and `search_for_account_number` defined you can say
`search_for_name OR NOT search_for_number AND search_for_account_number`
by specifying the following filter:

```
filter[binding]=search_for_name|(!search_for_phone_number&search_for_account_number)
```

Even though the brackets are useless here, you can use them in
more complex filters.

The following table summarizes the possible configuration options:
<table>
  <thead>
    <tr>
      <th>Type</th>
      <th>Symbol</th>
      <th>Example</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>AND</td>
      <td>&</td>
      <td>a&b</td>
    </tr>
    <tr>
      <td>OR</td>
      <td>|</td>
      <td>a|b</td>
    </tr>
    <tr>
      <td>NOT</td>
      <td>!</td>
      <td>!a</td>
    </tr>
    <tr>
      <td>Bracket</td>
      <td>()</td>
      <td>(a|b)&c</td>
    </tr>
  </tbody>
</table>

### Ordering ###

To specify a sort order of the results the `filter[order]` parameter
may be used. The value can be specified multiple times. To add
ordering you have to provide the name of the parameter which should
be ordered, not its alias!

If you want to order by `name`, `first_name` and in reverse order
`balance` you can do so by specifying the following query url
parameters:

```
filter[order]=name&filter[order]=first_name&filter[order]=desc(balance)
```

As you can see the `desc()` definition can be used to indicate
reverse ordering.

## Other Languages ##

This is a list of projects implementing the same API for other languages.
Currently this list only has one entry.

- Go - [go-filterparams](https://github.com/cbrand/go-filterparams)
- Python - [python-filterparams](https://github.com/cbrand/python-filterparams)
- JavaScript (Client) - [filterparams](https://github.com/cbrand/js-filterparams-client)
