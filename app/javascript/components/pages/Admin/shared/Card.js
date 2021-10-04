import React from 'react'
import styled from 'styled-components'

const Div = styled.div`
    background: #ffffff;
    box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.15);
    border-radius: 30px;
    padding: 50px;
    margin: 20px;
    display: flex;
    flex-direction: column;
    align-items: center;
    height: 100%;
`

const Card = (props) => {
    return <Div>{props.children}</Div>
}

export default Card
