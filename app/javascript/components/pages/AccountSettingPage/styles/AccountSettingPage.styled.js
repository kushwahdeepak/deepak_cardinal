import styled from 'styled-components'

export const Row = styled.div`
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    width: 100%;
    justify-content: ${(props) => (props.jContent ? props.jContent : 'unset')};
    align-items: ${(props) => (props.aItems ? props.aItems : 'unset')};
    margin-bottom: 30px;

    > p {
        margin: 0px;
    }

    > label {
        margin-bottom: 0px;
    }
`
export const Wrapper = styled.div`
    display: flex;
    flex-direction: row;
    width: 100%;
   
`
export const W3text = styled.span`
    font-style: normal;
    font-weight: 300;
    font-size: ${(props) => props.size};
    color: ${(props) => props.color};
    display: flex;
    flex-wrap: wrap;
`

export const Column = styled(Row)`
    flex-direction: column;
`
export const Error = styled.div`
    display: ${(props) => props.display};
`
export const Box = styled.div`
    display: flex;
    align-items: center;
    margin-bottom: 15px;

    > input {
        margin-right: 20px;
    }
`

export const Typography = styled.span`
    color: red;
    margin-top: 10px;
    font-size:14px;
    flex-basis: 51%;
    display: flex;
    flex-wrap: wrap;
`
