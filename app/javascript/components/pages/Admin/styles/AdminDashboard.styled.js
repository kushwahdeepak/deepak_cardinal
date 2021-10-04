import styled from 'styled-components'

export const BlockHeader = styled.div`
    background: #e6ebff;
    padding: 12px 48px;
    display: flex;
    justify-content: center;
    width: ${(props) =>
        props.width ? `${props.width}px` : 'auto'}
`

export const BlockBody = styled.div`
    border: 1px solid #e5ebff;
    display: inline-flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    width: 50%;
    padding: 10px;
`

export const DisplayPagination = styled.div`
    font-family: $default-font-family;
    font-style: normal;
    font-weight: 400;
    font-size: 12px;
    color: #696B74;
    text-align: left;
    margin-bottom: 10px;
    width:100%;
`
