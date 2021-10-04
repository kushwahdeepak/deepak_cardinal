import styled from 'styled-components'

export const AboutUsSection = styled.div`   
    display: flex;
`
export const Wrapper = styled.div`
background: linear-gradient(
        105.72deg,
        #e9efff -6.67%,
        #e8eaff 52.25%,
        #e2e1ff 103.38%
    );
`

export const AboutUsText = styled.div`
    display: flex;
    flex-direction: column;
    justify-content: center;
    flex-grow: 1;
    padding-left: 96px;
`

export const H1 = styled.h1`
    font-family: inherit;
    font-style: normal;
    font-weight: 800;
    font-size: 60px;
    line-height: 82px;
    color: #1d2447;
    margin-bottom: 0;
`

export const P = styled.p`
    font-family: inherit;
    font-style: normal;
    font-weight: ${(props) => props.weight || 'normal'};
    font-size: ${(props) => props.size || '24px'};
    line-height: ${(props) => props.height || '33px'};
    color: #1d2447;
    max-width: 400px;
    margin-top: ${(props) => props.marginTop || 0};
    margin-bottom: 0;
`

export const Button = styled.button`
    padding: 10px 40px;
    font-weight: 500;
    font-size: 20px;
    line-height: 27px;
    color: #ffffff;
    background: linear-gradient(
        94.67deg,
        #4c68ff -1.19%,
        #6077f4 53.94%,
        #8185ff 102.59%
    );
    border-radius: 50px;
    margin-top: 25px;
`

export const LookingForWorkSection = styled.div`
    display: flex;
    flex-direction: column;
    padding: 62px 0px;
    align-items: center;
`
export const TeamSection = styled.div`
    padding: 65px 120px;
    width: 100%;
`
export const Line = styled.div`
    border: 1px solid #4a4e64;
    width: 100%;
    margin-top: ${(props) => props.marginTop || 0};
`

export const Description = styled.p`
    font-weight: ${(props) => props.weight || 300};
    font-size: 20px;
    line-height: 33px;
    margin: 0px;
    padding: 0px 184px;
    color: #1d2447;
    text-align: justify;
    & span {
        line-height: 1.6;
    }
`