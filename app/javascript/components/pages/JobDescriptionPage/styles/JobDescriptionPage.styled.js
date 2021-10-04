import styled from 'styled-components'

export const Wrapper = styled.div`
    display: flex;
    flex-direction: column;
    width: 100%;
    height: 100%;
`
export const Box = styled.div`
    display: flex;
    margin-right: 10px;
`
export const Section = styled.div`
    display: flex;
    widows: 100%;
    flex-wrap: wrap;
    flex: ${(props) => (props.flex ? props.flex : 'unset')};
    align-self: ${(props) => (props.aSelf ? props.aSelf : 'unset')};
    flex-direction: ${(props) => (props.direction ? props.direction : 'unset')};

    @media (max-width: 670px) {
        margin-top: ${({ mTop }) => (mTop ? mTop : 'unset')};
    }
`

export const Skill = styled.span`
    background: #ebedfa;
    font-style: normal;
    font-weight: 400;
    font-size: 12px;
    border-radius: 20px;
    color: #768bff;
    padding: 6px 18px;
    margin-right: 5px;
    margin-bottom: 10px;
`

export const ImageContainer = styled.div`
    display: flex;
    border-radius: 10px;
    width: 150px;
    height: 150px;
    position: absolute;
    top: 143px;
    left: 101px;

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
    align-items: ${(props) => (props.aItems ? props.aItems : 'unset')};
    justify-content: ${(props) => (props.jContent ? props.jContent : 'unset')};
    margin-bottom: 12px;
`
export const HeaderRow = styled(Row)`
    justify-content: flex-end;
    margin-top: 25px;
`
export const W4text = styled.span`
    font-style: normal;
    font-weight: 400;
    font-size: ${(props) => props.size};
    color: ${(props) => props.color};
    display: flex;
`
export const W5text = styled(W4text)`
    font-weight: 500;
`
export const W8text = styled(W5text)`
    font-weight: 800;
`
export const W3text = styled(W4text)`
    font-weight: 300;
`

export const Container = styled.div`
    display: flex;
    flex-direction: ${(props) => props.direction};
    flex-wrap: wrap;
    flex: ${(props) => (props.flex ? props.flex : 'unset')};
    justify-content: ${(props) => (props.jContent ? props.jContent : 'unset')};
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
    box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.15);
`
export const Button2 = styled(Button)`
    background: #eaebff;
    border-radius: 5px;
`
export const Header = styled.div`
    background: linear-gradient(
        90.72deg,
        #dce6ff -1.05%,
        #e1dffe 50.61%,
        #b5c9ff 104.46%
    );
    width: 100%;
    height: 150px;
`
export const List = styled.div`
    font-style: normal;
    font-weight: 300;
    font-size: 20px;
    margin-left: 25px;
    color: #1d2447;
    display: flex;
    flex-direction: row;
    align-items: center;
`
export const Dot = styled.span`
    height: 10px;
    width: 10px;
    border-radius: 50%;
    background-color: #e3e7fe;
    margin-right: 20px;
    margin-top: 5px;
`
export const Body = styled.div`
    display: flex;
    flex-direction: column;
    margin-left: 100px;
    margin-right: 60px;
    width: 100%;
`
