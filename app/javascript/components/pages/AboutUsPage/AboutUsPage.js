import React from 'react'
import Image from 'react-bootstrap/Image'

import ImageOne from '../../../../assets/images/about_us_page_assets/about-us.png'
import {
    Wrapper,
    AboutUsSection,
    AboutUsText,
    P,
    TeamSection,
    Line,
    Description,
    Button,
    LookingForWorkSection,
} from './styles/AboutUsPage.styled'

const AboutUsPage = ({ description }) => {
    return (
        <Wrapper>
            <AboutUsSection>
                <AboutUsText>
                    <P>
                        From problem solving to innovational thinking, our team
                        strives for the best.
                    </P>
                </AboutUsText>
                <Image src={ImageOne} />
            </AboutUsSection>
            <TeamSection>
                <div className="d-flex flex-column align-items-center">
                    <Line />
                    <P size="40px" height="55px" marginTop="39px">
                       About Us
                    </P>
                    <Line marginTop="39px" />
                </div>
            </TeamSection>
            <Description
                weight="normal"
                dangerouslySetInnerHTML={{ __html: description }}
            />
            <LookingForWorkSection>
                <P size="30px" height="41px" style={{ maxWidth: 'unset' }}>
                    Looking for work? Join our team!
                </P>
                <Button
                    onClick={() => (window.location.href = '/users/sign_in')}
                >
                    View Open Positions
                </Button>
            </LookingForWorkSection>
        </Wrapper>
    )
}

export default AboutUsPage