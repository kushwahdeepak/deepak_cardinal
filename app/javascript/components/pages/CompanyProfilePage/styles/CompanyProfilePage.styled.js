import styled from 'styled-components'

export const Wrapper = styled.div`
    padding: 5px;
    width: 100%;
    max-height: 100%;
`
export const ImageContainer = styled.div`
    display: flex;
    border-radius: 10px;
    width: 150px;
    height: 150px;
    margin-bottom: 10px;

    > img {
        border-radius: 10px;
        width: 150px;
    }
`
export const Row = styled.div`
    display: flex;
    flex-direction: ${(props) => props.direction};
    flex-wrap: wrap;
    width: 100%;
    justify-content: ${(props) => (props.jContent ? props.jContent : 'unset')};
    margin-bottom: 12px;
`
export const W4text = styled.span`
    font-style: normal;
    font-weight: 400;
    font-size: ${(props) => props.size};
    color: ${(props) => props.color};
    display: flex;
`
export const W8text = styled.span`
    font-style: normal;
    font-weight: 800;
    color: #ffffff;
    font-size: ${(props) => props.size};
    color: ${(props) => props.color};
    display: flex;
`
export const InputContainer = styled.div`
    width: ${(props) => props.width};
    margin-bottom: 5px;
`
export const Container = styled.div`
    display: flex;
    flex-direction: ${(props) => props.direction};
    flex-wrap: wrap;
    flex: ${(props) => (props.flex ? props.flex : 'unset')};
    justify-content: ${(props) => (props.jContent ? props.jContent : 'unset')};
`
export const ScrollContainer = styled.div`
    display: flex;
    flex-direction: column;
    max-height: 550px;
    overflow-y: auto;
    margin-bottom: 15px;
`
export const Button = styled.button`
    background: linear-gradient(
        94.67deg,
        #4c68ff -1.19%,
        #6077f4 53.94%,
        #8185ff 102.59%
    );
    border-radius: 20px;
    padding: ${(props) => props.tb} ${(props) => props.lr};
    width: fit-content;
    display: flex;
    align-items: center;
`
