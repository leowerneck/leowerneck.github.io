import { parseBibTeX, formatTitle } from './bibtex-utils.js';

function formatTalk(bibData) {
    if (!bibData) return '';
    const { fields } = bibData;

    // Create separate elements for each part
    const titleElement = document.createElement('div');
    const typeElement = document.createElement('div');
    const venueElement = document.createElement('div');

    // Format title
    if (fields.title) {
        titleElement.innerHTML = formatTitle(fields.title);
    }

    // Format note
    if (fields.note) {
        typeElement.innerHTML = `<em>${fields.note.split(' ').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ')}</em>`;
    }

    // Format venue (journal) info
    if (fields.journal) {
        venueElement.innerHTML = `${fields.journal}, (${fields.year})`;
    }

    return {
        title: titleElement.innerHTML,
        type: typeElement.innerHTML,
        venue: venueElement.innerHTML
    };
}

document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.bibtex-entry').forEach(container => {
        const bibtexData = container.querySelector('.bibtex-data');
        const titleElement = container.querySelector('.talk-title');
        const typeElement = container.querySelector('.talk-type');
        const venueElement = container.querySelector('.talk-venue');


        if (bibtexData) {
            const parsed = parseBibTeX(bibtexData.textContent);
            const formatted = formatTalk(parsed);

            // Set the content for each section
            if (titleElement) titleElement.innerHTML = formatted.title;
            if (typeElement) typeElement.innerHTML = formatted.type;
            if (venueElement) venueElement.innerHTML = formatted.venue;

            bibtexData.style.display = 'none';
        }
    });

    document.querySelectorAll('.btn--bib').forEach(button => {
        button.addEventListener('click', function() {
            const targetId = this.getAttribute('data-target');
            const bibtexContent = document.querySelector(targetId);

            if (bibtexContent) {
                const isVisible = bibtexContent.style.display !== 'none';
                bibtexContent.style.display = isVisible ? 'none' : 'block';
                this.textContent = isVisible ? 'BibTeX' : 'Hide';
            }
        });
    });
});
