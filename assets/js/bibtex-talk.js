import { parseBibTeX, formatTitle } from './bibtex-utils.js';

function formatTalk(bibData) {
    if (!bibData) return '';
    const { fields } = bibData;

    // Create separate elements for each part
    const titleElement = document.createElement('div');
    const typeElement = document.createElement('div');
    const eventnameElement = document.createElement('div');
    const addressElement = document.createElement('div');

    // Format title
    if (fields.title) {
        titleElement.innerHTML = formatTitle(fields.title);
    }

    // Format note
    if (fields.note) {
        typeElement.innerHTML = `<em>${fields.note.split(' ').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ')}</em>`;
    }

    // Format booktitle (event name)
    if (fields.booktitle) {
        eventnameElement.innerHTML = `<strong>${fields.booktitle}</strong>`
    }

    // Format address (journal) info
    if (fields.address) {
        addressElement.innerHTML = `${fields.address} (${fields.year})`;
    }

    return {
        title: titleElement.innerHTML,
        type: typeElement.innerHTML,
        eventname: eventnameElement.innerHTML,
        address: addressElement.innerHTML
    };
}

document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.bibtex-entry').forEach(container => {
        const bibtexData = container.querySelector('.bibtex-data');
        const titleElement = container.querySelector('.talk-title');
        const typeElement = container.querySelector('.talk-type');
        const eventElement = container.querySelector('.talk-event');
        const addressElement = container.querySelector('.talk-address');


        if (bibtexData) {
            const parsed = parseBibTeX(bibtexData.textContent);
            const formatted = formatTalk(parsed);

            // Set the content for each section
            if (titleElement) titleElement.innerHTML = formatted.title;
            if (typeElement) typeElement.innerHTML = formatted.type;
            if (eventElement) eventElement.innerHTML = formatted.eventname;
            if (addressElement) addressElement.innerHTML = formatted.address;

            // Set up the button links
            if (parsed && parsed.fields) {
                const slidesButton = container.querySelector('.btn--slides');
                if (slidesButton && parsed.fields.publishedat) {
                    slidesButton.href = `${parsed.fields.publishedat}`;
                } else if (slidesButton) {
                    slidesButton.style.display = 'none';
                }
            }

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

    document.querySelectorAll('.bibtex-thumbnail video').forEach(video => {
        video.autoplay = true;
        video.loop = true;
        video.muted = true;
    });
});
