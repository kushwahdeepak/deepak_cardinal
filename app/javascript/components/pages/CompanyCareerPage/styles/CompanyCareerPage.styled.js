import styled from 'styled-components'

export const HeaderWithLogo = styled.div`
    background: linear-gradient(
        90.72deg,
        #dce6ff -1.05%,
        #e1dffe 50.61%,
        #b5c9ff 104.46%
    );
    height: 150px;
    max-height: 150px;
    position: relative;
    width: 100%;

    & div.logo {
        position: absolute;
        width: 150px;
        height: 150px;
        background: #ffffff;
        box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        border-radius: 10px;
        top: 75px;
        left: 113px;

        & img {
            width: 150px;
            height: 150px;
            object-fit: contain;
        }
    }
`

export const Container = styled.div`
    margin-left: 113px;
    margin-right: 60px;
    margin-bottom: 40px;

    @media (max-width: 600px) {
        margin: 40px;
    }
`

export const H1 = styled.h1`
    font-family: inherit;
    font-weight: 500;
    font-size: 32px;
    line-height: 44px;
    color: #1d2447;
    margin-bottom: ${(props) =>
        props.marginBottom != undefined ? props.marginBottom : 0};
    margin-top: ${(props) =>
        props.marginTop != undefined ? props.marginTop : 0};

    @media (max-width: 600px) {
        text-align: center;
    }
`

export const P = styled.p`
    font-family: inherit;
    font-weight: ${(props) => props.weight || 'normal'};
    font-size: ${(props) => props.size || '24px'};
    line-height: ${(props) => props.height || '33px'};
    color: ${(props) => props.color || '#1D2447'};
    margin-bottom: 0px;
    margin-top: ${(props) =>
        props.marginTop != undefined ? props.marginTop : '0px'};
    margin-left: ${(props) =>
        props.marginLeft != undefined ? props.marginLeft : 0};
    text-align: ${(props) => (props.center ? 'center' : 'unset')};
`

export const JobCategory = styled.div`
    padding: 6px 12px;
    background: #eaebff;
    border-radius: 5px;
    display: inline-block;
`

export const Circle = styled.div`
    background: #e3e7fe;
    width: 10px;
    height: 10px;
    border-radius: 50%;
    margin-left: ${(props) =>
        props.marginLeft != undefined ? props.marginLeft : 0};
`

export const AboutCompany = styled.div`
    max-width: 400px;
`

export const Div = styled.div`
    div.careers {
        margin-left: 70px;
        flex-grow: 1;
    }

    @media (max-width: 700px) {
        display: flex;
        flex-direction: column;

        div.careers {
            margin-left: 0;
            margin-top: 20px;
        }
    }

    @media (max-width: 600px) {
        div.careers > div {
            display: flex;
            flex-direction: column;
        }
    }
`

export const SearchField = styled.div`
    background: #f6f7fc;
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    border-radius: 5px;
    height: 40px;
    display: flex;
    align-items: center;
    padding-left: 10px;
    padding-right: 10px;
    max-width: 350px;
    width: 350px;

    & input {
        border: none;
        outline: none;
        background: transparent;
        margin-left: 12px;
        width: 100%;
    }

    & input::placeholder {
        font-family: inherit;
        font-style: normal;
        font-weight: normal;
        font-size: 14px;
        color: #c6cdf4;
    }
`
