import styled from 'styled-components'
import {  Form } from 'formik'

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
    align-items: center;
    justify-content: center;
`
export const W5text = styled(W4text)`
    font-weight:500;
`
export const W8text = styled(W4text)`
    font-weight: 800;
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
    align-items: ${(props) => (props.aItems ? props.aItems : 'unset')};
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

export const H1 = styled.h1`
    font-size: 30px;
    line-height: 41px;
    text-align: center;
    color: #393f60;
    margin-bottom: 30px;
`

export const StyledForm = styled(Form)`
    background: #ffffff;
    // box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.1);
    border-radius: 20px;
    max-width: 800px;
    width: 800px;
    padding: 40px 50px;
`

export const InfoText = styled.p`
    font-size: 12px;
    line-height: 16px;
    color: #828bb9;
    margin-top: -15px;
`

export const Logo = styled.div`
    background: ${(props) =>
        props.image
            ? `url(${props.image}) no-repeat center center`
            : `linear-gradient(
        133.96deg,
        #ced9ff -13.41%,
        #eeeefd 51.28%,
        #ccceff 114.63%
    )`};
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-size: 20px;
    line-height: 27px;
    text-align: center;
    color: #9fabe8;
    padding: 35px 30px;
    height: 150px;
    width: 150px;
`
