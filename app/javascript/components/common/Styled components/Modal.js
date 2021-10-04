import React from 'react'

import styled from 'styled-components'

const Wrapper = styled.div`

`

const ModalDiv = styled.div.attrs((props) => ({
    width: props.width || '75%',
}))`
z-index: 9999;
position: fixed;
top :50%;
left: 50%;
padding :15px 25px;
transform: translate(-50%, -50%);
background: #FFFFFF;
box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.15);
border-radius: 25px;
width: ${(props)=> props.width};


display: flex;
flex-wrap: wrap;
`

const Overlay = styled.div`
z-index :9998;
position:fixed;
width:100%;
height:100%;
top :0;
left :0;
`

function Modal(props) {
    const { isOpen, children, onBlur, width } = props

    if (isOpen === false) return null

    return (
        <Wrapper>
            <ModalDiv width={width}>{children}</ModalDiv>
            <Overlay onClick={() => onBlur()}></Overlay>
        </Wrapper>
    )
}

export default Modal
