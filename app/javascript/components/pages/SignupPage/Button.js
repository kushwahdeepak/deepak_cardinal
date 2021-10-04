import React from 'react'
import styled from 'styled-components'

const Button = ({ className, style, children, ...props }) => {
    return (
        <button className={className || ''} style={style || {}} {...props}>
            {children}
        </button>
    )
}

const StyledButton = styled(Button)`
    background: linear-gradient(
        94.67deg,
        #5f78ff -1.19%,
        #7185f2 53.94%,
        #8d91ff 102.59%
    );
    border-radius: 20px;
    padding: 9px 31px;
    font-weight: 800;
    font-size: 16px;
    line-height: 22px;
    text-align: center;
    color: #ffffff;
    &: disabled {
        background: lightgray;
    }
`

export default StyledButton
