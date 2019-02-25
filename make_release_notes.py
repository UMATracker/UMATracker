import re
import argparse

ARG_PARSER = argparse.ArgumentParser(
    description=(
        'Generate UMATracker release notes from a Markdown file.'
    )
)
ARG_PARSER.add_argument(
    '--heading_size', type=int, required=True, choices=range(2, 10),
    help=(
        'Heading size to include. Should be larger than 2.\n'
        'Set 2 if you want h2 headings for a release notes.'
    )
)
ARG_PARSER.add_argument(
    '--num_of_headings', type=int, required=True, choices=range(1, 10),
    help='Number of headings to include.'
)
ARG_PARSER.add_argument(
    '--markdown_path', type=str, required=True,
    help='Markdown path to process.'
)


def main(size, num, input_path):
    heading_str =  '{} '.format('#' * size)
    parent_heading_str =  '{} '.format('#' * (size - 1))

    heading_regex = re.compile('{}.*'.format(heading_str))
    parent_regex = re.compile('{}.*'.format(parent_heading_str))

    output_lines = []

    with open(input_path, encoding='utf8') as ifd:
        h_count = 0

        for line in ifd:
            m = heading_regex.match(line)
            pm = parent_regex.match(line)

            if m:
                h_count = h_count + 1

            if h_count > num:
                break
            elif h_count == num and pm:
                break

            if num >= h_count > 0:
                output_lines.append(line)

    with open('RELEASE_NOTES.md', mode='w', encoding='utf8') as ofd:
        ofd.writelines(output_lines) 


if __name__ == '__main__':
    parsed_args = ARG_PARSER.parse_args()
    size = parsed_args.heading_size
    num = parsed_args.num_of_headings
    input_path = parsed_args.markdown_path

    main(size, num, input_path)