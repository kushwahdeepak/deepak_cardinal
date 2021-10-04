import React from 'react'
import styled from 'styled-components'

const Paragraph = styled.p`
    font-weight: ${(props) => props.weight || 'normal'};
    font-size: ${(props) => props.size || '22px'};
    line-height: ${(props) => props.height || '30px'};
    color: ${(props) => props.color || '#1D2447'};
    margin-bottom: ${(props) => props.marginBottom || '0px'};
    margin-top: ${(props) => props.marginTop || '0px'};
    text-align: ${(props) => (props.center ? 'center' : 'unset')};
    word-break: break-all;
`

const P = ({ children, ...rest }) => {
    return <Paragraph {...rest}>{children}</Paragraph>
}

export default P
