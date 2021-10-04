import styled from 'styled-components'
import Row from 'react-bootstrap/Row'

export const H1 = styled.h1`
    font-family: inherit;
    font-style: normal;
    font-weight: 800;
    font-size: 60px;
    line-height: 82px;
    color: #272e50;
    margin-bottom: 0px;
`

export const P = styled.p`
    font-family: inherit;
    font-style: normal;
    font-weight: ${(props) => props.weight || 'normal'};
    font-size: ${(props) => props.size || 22}px;
    line-height: ${(props) => props.height || 30}px;
    color: ${(props) => props.color || '#272e50'};
    margin-bottom: 0px;
    margin-top: ${(props) =>
        props.marginTop != undefined ? props.marginTop : 0}px;
`

export const Button = styled.button`
    background: linear-gradient(
        94.67deg,
        #4c68ff -1.19%,
        #6077f4 53.94%,
        #8185ff 102.59%
    );
    border-radius: 50px;
    padding: 10px 30px;
    font-family: inherit;
    font-style: normal;
    font-weight: 800;
    font-size: 18px;
    line-height: 25px;
    text-align: center;
    color: #ffffff;
    margin-left: ${(props) => props.marginLeft || 0}px;

    @media (max-width: 500px) {
        margin-left: 0;
        margin-top: 10px;
    }
`

export const TopSection = styled(Row)`
    padding-top: ${(props) => props.paddingTop || 90}px;
    padding-left: 78px;
    padding-right: 78px;
    margin-left: 0;
    margin-right: 0;

    @media (max-width: 1199px) {
        display: flex;
        justify-content: center;
    }

    @media (max-width: 900px) {
        padding: 40px;
    }
`

export const Card = styled.div`
    background: #f6f8ff;
    border-radius: 5.56963px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    width: 200px;
    height: 110px;
    margin-bottom: 10px;
`
