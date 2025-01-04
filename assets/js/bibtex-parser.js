// Save this as assets/js/bibtex-parser.js
function parseBibTeX(bibtexStr) {
  // Extract entry type and key
  const typeMatch = bibtexStr.match(/@(\w+)\s*{\s*([^,]*),/);
  if (!typeMatch) return null;

  const type = typeMatch[1];
  const key = typeMatch[2];

  // Extract fields with improved handling of quoted content
  const fields = {};
  const fieldRegex = /(\w+)\s*=\s*(?:"([^"]*)"|{([^}]*)})/g;
  let match;

  while ((match = fieldRegex.exec(bibtexStr)) !== null) {
    fields[match[1].toLowerCase()] = match[2] || match[3];
  }

  return { type, key, fields };
}

function formatAuthorName(authorStr) {
  // Split at comma to separate last name from first/middle names
  const [lastName, firstNames] = authorStr.trim().split(',').map(s => s.trim());

  if (!firstNames) return lastName; // Handle case with no comma

  // Get first initial and any middle initials
  const names = firstNames.split(' ').filter(n => n);
  const initials = names.map(name => name.charAt(0)).join('.');

  // Return in "F.M. Last" format
  return `${initials}. ${lastName}`;
}

function formatAuthors(authorStr, boldAuthor = "L.R. Werneck") {
  // Replace "others" with italicized "et al."
  authorStr = authorStr.replace(/\band\s+others\b/, 'and <i>et al</i>.');

  return authorStr.split(' and ')
    .map(author => {
      author = author.trim();
      // Skip formatting for the et al. part
      if (author.includes('et al')) return author;

      const formattedName = formatAuthorName(author);

      // Check if this is the author to be bold (compare original unformatted name)
      if (formattedName === boldAuthor) {
        return `<strong>${formattedName}</strong>`;
      }
      return formattedName;
    })
    .join(', ');
}

function formatCitation(bibData) {
  if (!bibData) return '';

  const { fields } = bibData;
  const parts = [];

  if (fields.author) {
    const authorsElement = document.createElement('span');
    authorsElement.innerHTML = formatAuthors(fields.author);
    parts.push(authorsElement.outerHTML);
  }

  if (fields.title) {
    // Remove any remaining braces and add italics
    const cleanTitle = fields.title.replace(/[{}]/g, '');
    parts.push(`<i>${cleanTitle}</i>`);
  }

  if (fields.journal) {
    parts.push(fields.journal);
  }

  if (fields.volume) {
    parts.push(fields.volume);
  }

  if (fields.number) {
    parts.push(`(${fields.number})`);
  }

  if (fields.pages) {
    parts.push(fields.pages);
  }

  if (fields.year) {
    // Add year in parentheses with bold numbers
    parts.push(`(<strong>${fields.year}</strong>).`);
  }

  return parts.join(', ');
}

document.addEventListener('DOMContentLoaded', function() {
  document.querySelectorAll('.bibtex-entry').forEach(container => {
    const bibtexData = container.querySelector('.bibtex-data');
    const displayElement = container.querySelector('.bibtex-details p');

    if (bibtexData && displayElement) {
      const parsed = parseBibTeX(bibtexData.textContent);
      displayElement.innerHTML = formatCitation(parsed);
      bibtexData.style.display = 'none';
    }
  });
});
