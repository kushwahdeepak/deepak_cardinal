import styled from 'styled-components'
import Col from 'react-bootstrap/Col'

export const H1 = styled.h1`
    font-family: inherit;
    font-weight: 800;
    font-size: 50px;
    line-height: 68px;
    color: #262b41;
    margin-bottom: ${(props) => props.marginBottom || 0}px;
    margin-top: ${(props) => props.marginTop || 0}px;
`

export const P = styled.p`
    font-family: inherit;
    font-weight: ${(props) => props.weight || 'normal'};
    font-size: ${(props) => props.size || 22}px;
    line-height: ${(props) => props.height || 30}px;
    color: ${(props) => props.color || '#262b41'};
    margin-bottom: 0px;
    margin-top: ${(props) => props.marginTop || 0}px;
    text-align: ${(props) => (props.center ? 'center' : 'unset')};
`

export const Button = styled.button`
    padding: 10px 40px;
    font-weight: 800;
    font-size: 18px;
    line-height: 25px;
    color: #ffffff;
    background: linear-gradient(
        94.67deg,
        #4c68ff -1.19%,
        #6077f4 53.94%,
        #8185ff 102.59%
    );
    border-radius: 50px;
    margin-top: 20px;
    align-self: flex-start;
`

export const CONTAINER = styled.div`
    max-width: 1000px;
    margin: 0 auto 195px;
`

export const GRID = styled.div`
    background: #f9faff;
    border-radius: 5px;
    margin-top: 45px;
    padding: 25px;
`

export const COL = styled(Col)`
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 30px 50px;
`

export const A = styled.a`
    font-family: inherit;
    font-style: normal;
    font-weight: 800;
    font-size: 16px;
    line-height: 22px;
    text-align: center;
    color: #7a8ef5;
    margin-top: 35px;
`
