export const colourStyles = {
    control: (styles) => ({
        ...styles,
        backgroundColor: '#fffff',
        color: '#005cbf',
        border: 'none',
        texTransform:'capitalize'
    }),
    valueContainer:(styles)=>({
        ...styles,
        texTransform:'capitalize'
    }),
    option: (styles) => ({
        ...styles,
        fontFamily: 'Avenir, "Lato", sans-serif',
        texTransform: 'capitalize',
        zIndex:999999,
    }),
    menuOptions:(styles)=>({
        ...styles,
        fontFamily: 'Avenir, "Lato", sans-serif',
        texTransform: 'capitalize',
    }),
    dropdownIndicator: (styles) => ({
        ...styles,
        color: `hsl(0, 0%, 20%)`,
    }),
    indicatorSeparator: (styles) => ({
        ...styles,
        display: 'none',
    }),
    menuPortal:(styles) =>({
        ...styles,
        zIndex:999999999
    }),
    menu:(styles) =>({
        ...styles,
        zIndex:999999999
    })
}