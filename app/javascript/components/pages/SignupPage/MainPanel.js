import React from 'react'
import styled from 'styled-components'

const Panel = styled.div`
    flex-grow: 2;
    height: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    padding-top: 90px;
    margin-bottom: 50px;
    
`

const MainPanel = (props) => {
    return <Panel>{props.children}</Panel>
}

export default MainPanel
