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

function formatAuthors(authorStr, myName = "L.R. Werneck") {
  // Split authors into array
  const authors = authorStr.split(' and ').map(a => a.trim());

  // Find my position in the author list
  const myIndex = authors.findIndex(author => formatAuthorName(author) === myName);

  // If there are 5 or fewer authors, handle normally
  if (authors.length <= 5) {
    if (myIndex === -1) {
      return authors.map(author => formatAuthorName(author)).join(', ');
    }

    let formattedAuthors = authors
      .map((author, index) => {
        if (index === myIndex) {
          return `<strong>${myName}</strong>`;
        }
        return formatAuthorName(author);
      });

    // Add "and" before the last author if needed
    if (formattedAuthors.length > 1) {
      formattedAuthors[formattedAuthors.length - 1] = 'and ' + formattedAuthors[formattedAuthors.length - 1];
    }

    return formattedAuthors.join(', ');
  }

  // More than 5 authors
  if (myIndex === -1 || myIndex >= 5) {
    // Show first 5 authors and et al.
    const firstFive = authors.slice(0, 5).map(author => formatAuthorName(author));
    if (myIndex > 5) {
      return firstFive.join(', ') + ', ' + `<strong>${myName}</strong>` + ' et al.';
    }
    return firstFive.join(', ') + ' et al.';
  }

  // I'm among the first 5 authors
  let formattedAuthors = authors.slice(0, 5).map((author, index) => {
    if (index === myIndex) {
      return `<strong>${myName}</strong>`;
    }
    return formatAuthorName(author);
  });

  return formattedAuthors.join(', ') + ' et al.';
}

function formatTitle(title) {
  // List of words to keep lowercase
  const lowercaseWords = new Set([
    'a', 'an', 'the', 'and', 'but', 'or', 'for', 'nor', 'on', 'at',
    'to', 'by', 'in', 'of', 'with', 'as'
  ]);

  // List of special terms to preserve exact capitalization
  const preserveTerms = new Map([
    ['illinoisgrmhd', 'IllinoisGRMHD'],
    ['nrpy+', 'NRPy+'],
    ['retinas', 'RETINAS'],
    ['nrpycritcol', 'NRPyCritCol'],
    ['sfcollapse1d', 'SFcollapse1D'],
    ['groovy', 'GRoovy'],
    ['grhayl', 'GRHayL'],
    ['harm3d+nuc', 'HARM3D+NUC'],
    ['1d', '1D'],
    ['2d', '2D'],
    ['3d', '3D'],
  ]);

  // Remove any remaining braces and split into words
  const cleanTitle = title.replace(/[{}]/g, '');
  const words = cleanTitle.split(/\s+/);

  // Capitalize words according to rules
  const titleCase = words.map((word, index) => {
    // Remove punctuation from the word for comparison
    const match = word.match(/^([a-zA-Z0-9+]+)([.,:;!?]*)$/);
    const baseWord = match ? match[1] : word;
    const punctuation = match ? match[2] : '';

    // Convert base word to lowercase for comparison
    const lowercaseWord = baseWord.toLowerCase();

    // Check if word is a special term that needs preservation
    if (preserveTerms.has(lowercaseWord)) {
      return preserveTerms.get(lowercaseWord) + punctuation;
    }

    // Always capitalize first and last word
    if (index === 0 || index === words.length - 1) {
      return baseWord.charAt(0).toUpperCase() + baseWord.slice(1).toLowerCase() + punctuation;
    }
    // Check if word should remain lowercase
    if (lowercaseWords.has(lowercaseWord)) {
      return baseWord.toLowerCase() + punctuation;
    }
    // Capitalize first letter of other words
    return baseWord.charAt(0).toUpperCase() + baseWord.slice(1).toLowerCase() + punctuation;
  });

  return `<strong><i>${titleCase.join(' ')}</i></strong>`;
}

function formatCitation(bibData) {
  if (!bibData) return '';
  const { fields } = bibData;

  // Create separate elements for each part
  const titleElement = document.createElement('div');
  const authorsElement = document.createElement('div');
  const journalElement = document.createElement('div');

  // Format title
  if (fields.title) {
    titleElement.innerHTML = formatTitle(fields.title);
  }

  // Format authors
  if (fields.author) {
    authorsElement.innerHTML = formatAuthors(fields.author);
  }

  // Format journal info
  if (fields.journal) {
    journalElement.innerHTML = `${fields.journal}, ${fields.volume} (${fields.number}) ${fields.pages} (${fields.year})`;
  } else if (fields.eprint && fields.archiveprefix === "arXiv") {
    journalElement.innerHTML = `arXiv:${fields.eprint} [${fields.primaryclass}] (${fields.year})`;
  }

  return {
    title: titleElement.innerHTML,
    authors: authorsElement.innerHTML,
    journal: journalElement.innerHTML
  };
}

document.addEventListener('DOMContentLoaded', function() {
  document.querySelectorAll('.bibtex-entry').forEach(container => {
    const bibtexData = container.querySelector('.bibtex-data');
    const titleElement = container.querySelector('.paper-title');
    const authorsElement = container.querySelector('.paper-authors');
    const journalElement = container.querySelector('.paper-journal');

    if (bibtexData) {
      const parsed = parseBibTeX(bibtexData.textContent);
      const formatted = formatCitation(parsed);

      // Set the content for each section
      if (titleElement) titleElement.innerHTML = formatted.title;
      if (authorsElement) authorsElement.innerHTML = formatted.authors;
      if (journalElement) journalElement.innerHTML = formatted.journal;

      // Set up the button links
      if (parsed && parsed.fields) {
        const journalButton = container.querySelector('.btn--journal');
        if (journalButton && parsed.fields.doi) {
          journalButton.href = `https://doi.org/${parsed.fields.doi}`;
        } else if (journalButton) {
          journalButton.style.display = 'none';
        }

        const arxivButton = container.querySelector('.btn--arxiv');
        if (arxivButton && parsed.fields.eprint) {
          arxivButton.href = `https://arxiv.org/abs/${parsed.fields.eprint}`;
        } else if (arxivButton) {
          arxivButton.style.display = 'none';
        }
      }

      bibtexData.style.display = 'none';
    }
  });
});
