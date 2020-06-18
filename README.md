Just a place for tools using YAML::PP

## yamlpp-schema-convert

Experimental script to convert types like booleans and numbers in a given
YAML file from YAML 1.1 to 1.2. Keeps all whitespace and comments.

See example files [in.yaml](/data/in.yaml) and [out.yaml](/data/out.yaml).

Example usage:

    % echo 'yes' | perl bin/yamlpp-schema-convert -
    true
    % echo '0o7' | perl bin/yamlpp-schema-convert -
    '0o7'
    % perl bin/yamlpp-schema-convert data/in.yaml > data/out.yaml
    % vimdiff data/in.yaml data/out.yaml

To highlight the files and see trailing spaces, you can use:

    % yamlpp-highlight data/in.yaml
    % yamlpp-highlight data/out.yaml

### Dependencies

Perl modules:
* YAML::PP 0.22 [Repology](https://repology.org/project/perl:yaml-pp/versions)
* Getopt::Long::Descriptive [Repology](https://repology.org/project/perl:getopt-long-descriptive/versions)

### Limitations

Because this uses the lowlevel token API, it can't detect certain things.

Correct:

    - YES
    # will be converted to
    - true

Correct:

    - !!str YES
    # not converted
    - !!str YES

Not correct:

    - !!str
       YES
    # will be converted to
    - !!str
       true

Also it doesn't convert quoted strings:

    - !!bool 'yes'
    # not converted
    - !!bool 'yes'
