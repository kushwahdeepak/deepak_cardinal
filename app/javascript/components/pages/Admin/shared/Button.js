import React from 'react'
import styled from 'styled-components'

const StyledButton = styled.button`
    background: ${(props) =>
        props.background ||
        `linear-gradient(
        94.67deg,
        #4c68ff -1.19%,
        #6077f4 53.94%,
        #8185ff 102.59%)`};
    border-radius: ${(props) => props.radius || '20px'};
    padding: ${(props) => props.padding || '13px 20px'};
    font-family: Avenir, "Lato", sans-serif !important;
    font-style: normal !important;
    font-weight: 800 !important;
    font-size: 16px !important;
    line-height: 16px;
    text-align: center;
    color: #fff;
    width: ${(props) => props.width || 'unset'};
    height: ${(props) => props.height || 'unset'};
`

const Button = ({ children, ...rest }) => (
    <StyledButton {...rest}>{children}</StyledButton>
)

export default Button
