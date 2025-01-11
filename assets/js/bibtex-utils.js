export function parseBibTeX(bibtexStr) {
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

export function formatTitle(title) {
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
