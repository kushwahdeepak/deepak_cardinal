import styled from 'styled-components'

export const Wrapper = styled.div`
    display: flex;
`
export const Box = styled.div`
    display: ${({ display }) => display};
    flex-direction: column;
    width: 100%;
`
export const Container = styled.div`
    display: flex;
    flex-direction: ${({ direction }) => direction};
`
export const TabContainer = styled.div`
    display: flex;
    flex-direction: row;
    margin-bottom: 20px;
`
export const Tab = styled.div`
    margin-right: 30px;
`

export const W4text = styled.span`
    font-style: normal;
    font-weight: 400;
    font-size: ${(props) => props.size};
    color: ${(props) => props.color};
    display: flex;
    cursor: pointer;
`
export const W5text = styled(W4text)`
    font-weight: 400;
`

export const W8text = styled(W4text)`
    font-weight: 800;
`

export const Card = styled.div`
    display: flex;
    flex-direction: row;
    align-items: center;
`
export const InfoContainer = styled.div`
    display: flex;
    flex-direction: column;
    align-items: ${(props)=> props.aItems ? props.aItems :'unset'};
    justify-content: ${(props) => (props.jContent ? props.jContent : 'unset')};
    `

export const Link = styled.a`
    background-color: #4c68ff;
    color: white;
    border: 1px solid;
    transition: 0.2s cubic-bezier(0.3, 0, 0.5, 1);
    transition-property: color, background-color, border-color;
    height: fit-content;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 25px;
    padding: 8px 25px;
    margin-right: 10px;
`
export const PainatorContainer = styled.div`
    margin-top: 20px;
    align-items: center;
    display: flex;
    justify-content: center;
`
