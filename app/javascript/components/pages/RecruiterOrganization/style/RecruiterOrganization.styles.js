export const colourStyles = {
    control: (styles) => ({
        ...styles,
        backgroundColor: '#ebedfa',
        width: '12em',
        color: '#4c68ff !important',
        border: 'none',
        borderRadius: '20px',
    }),
    singleValue:()=>({
        color: '#4c68ff !important'
    }),
    option: (styles) => ({
        ...styles,
        fontFamily: 'Avenir, "Lato", sans-serif',
        texTransform: 'capitalize',
    }),
    dropdownIndicator: (styles) => ({
        ...styles,
        color: '#4c68ff',
    }),
    indicatorSeparator: (styles) => ({
        ...styles,
        display: 'none',
    }),
}