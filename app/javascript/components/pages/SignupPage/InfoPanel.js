import React from 'react'
import styled from 'styled-components'

const Panel = styled.div`
    flex-grow: 1;
    background: #f9faff;
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 100px 70px;
    height: 100%;
    max-width: 500px;

    @media only screen and (min-device-width : 320px) and (max-device-width : 1072px){
        padding: 45px 15px !Important;
        height: auto;
        max-width: 100%;
    }
`

const InfoPanel = (props) => {
    return <Panel style={props.style}>{props.children}</Panel>
}

export default InfoPanel
