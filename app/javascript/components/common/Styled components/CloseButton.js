import React, { useEffect } from 'react'
import feather from 'feather-icons'
import styled from 'styled-components'

const Button = styled.button`
    width: 30px;
    height: 30px;
    border-radius: 50%;
    background: #8599ff;
    display: flex;
    align-items: center;

    > svg {
        transform: scale(1.1);
        color: #ffff;
    }
`

function CloseButton(props) {
    const { handleClick } = props
    useEffect(() => {
        feather.replace()
    })
    return (
        <Button onClick={handleClick}>
            <i data-feather="x"></i>
        </Button>
    )
}

export default CloseButton
