import React from 'react'
import styled from 'styled-components'

const Wrapper = styled.div`
    background: #ffffff;
    box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.15);
    padding: 20px 50px;
    width: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
`

const TableWrapper = ({ children }) => {
    return <Wrapper>{children}</Wrapper>
}

export default TableWrapper
