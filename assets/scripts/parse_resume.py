""" Parse my resume from TeX format to Markdown/HTML """

from datetime import date
from os.path import exists as path_exists
from re import compile, findall, sub
from sys import argv


class ResumeSection:
    def __init__(self, title: str, icon: str, contents: str):
        self.title = title
        self.icon = icon
        self.contents = contents


def pascal_or_camel_to_kebab(pascal: str) -> str:
    """Convert a string from Pascal or Camel case to kebab case"""
    kebab = ""
    for char in pascal:
        if char.islower():
            kebab += char
            continue

        if kebab != "":
            kebab += "-"

        kebab += char.lower()

    return kebab


def icon_tex_to_html(tex_icon: str) -> str:
    """Convert a Fontawesome icon string from tex to html"""
    if r"\faIcon" in tex_icon:
        return "fa fa-" + pascal_or_camel_to_kebab(tex_icon[8:-2])
    return "fa fa-" + pascal_or_camel_to_kebab(tex_icon[3:])


class Parser:
    def __init__(self, filename: str) -> None:
        """Initialize Parser class"""
        if not path_exists(filename):
            raise RuntimeError(f"File {filename} does not exist.")

        self.filename = filename
        self.replace_bolds = compile(r"(?:{\\bfseries\s|\\textbf{)(.*?)}")
        self.replace_italics = compile(r"(?:{\\itshape\s|\\textit{)(.*?)}")
        self.replace_code = compile(r"\\CodeEntry{(.*?)}{(.*?)}")
        self.latex_replacements = (
            ("~", " "),
            ("$\\vert$", "\\|"),
            ("\\&", "&"),
            (".\\", "."),
        )

        self.sections: list[ResumeSection] = []

    def latex_to_md(self, latex: str) -> str:
        """Converts *some* LaTeX to markdown"""
        md = latex.strip()
        for old, new in self.latex_replacements:
            md = md.replace(old, new)
        md = self.replace_bolds.sub(r"**\1**", md)
        md = self.replace_italics.sub(r"*\1*", md)
        md = self.replace_code.sub(r"**\1**: *\2*", md)

        if r"\hfill" in md:
            left, right = md.split(r"\hfill")
            if r"\hphantom" in right:
                right = sub(r"\s*\\hphantom{.*?}", "", right)
            md = f"(*{right.strip()}*) {left.strip()}"

        return md

    def parse(self) -> None:
        """Parse resume, extracting section and their contents"""

        list_level = 0
        prefix = "* "
        for line in open(self.filename, "r"):
            if len(line) == 0 or len(line.lstrip()) == 0:
                continue

            if line.lstrip()[0] == "%":
                continue

            if (
                line.strip()[:-1] == r"\begin{itemize}"
                or line.strip()[:-1] == r"\begin{enumerate}"
            ):
                list_level += 1
                prefix = "  " * (list_level - 1) + "* "
                continue

            if line.strip() == r"\end{itemize}" or line.strip() == r"\end{enumerate}":
                list_level -= 1
                prefix = " " * (list_level - 1) + "* "
                continue

            if line[:8] == r"\Section":
                icon, title = findall(r"\Section{(.*?)}{(.*?)}", line)[0]
                self.sections.append(ResumeSection(title, icon_tex_to_html(icon), ""))
                continue

            if len(self.sections) == 0 or r"\item" not in line:
                continue

            contents = f"{prefix}{self.latex_to_md(line.strip()[5:])}\n"
            self.sections[-1].contents += contents

    def to_string(self) -> str:
        """Converts parsed resume to a string"""
        string = ""

        for section in self.sections:
            string += f'#### <span style="color:navy"><i class="{section.icon}"></i> *{section.title}*</span>\n'
            string += section.contents + "\n"

        return string


if __name__ == "__main__":
    parser = Parser(argv[1])
    parser.parse()
    today = date.today()
    today_long = today.strftime("%B %d, %Y")
    today_short = today.strftime("%Y-%m-%d")
    resume_path = f"/assets/docs/LW-Resume-{today_short}.pdf"
    cv_path = f"/assets/docs/LW-CV-{today_short}.pdf"
    with open("resume-cv.md", "w") as f:
        f.write(
            f"""---
title: Resume/CV
permalink: /resume-cv/
---

This webpage was last updated on **{today}**.

You can view my resume below. Additionally, you can download PDF versions of my [resume]({resume_path}) or [academic CV]({cv_path}).
"""
        )
        f.write(parser.to_string())
