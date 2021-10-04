import React, { useState, useEffect } from 'react'
import Image from 'react-bootstrap/Image'

import CareersImage from '../../../../assets/images/careers_page_assets/careers.png'
import RightArrowIcon from '../../../../assets/images/careers_page_assets/arrow-right.svg'
import './styles/careerspagemodule.scss'

import {
    JoinUsSection,
    JoinUsText,
    H1,
    P,
    CurrentOpeningsSection,
    Line,
    Openings,
    Card,
    Button,
    LookingForWorkSection,
} from './styles/CareersPage.styled'
import { firstCharacterCapital } from '../../../utils'

const DisplayOpening = ({ category, openings }) => {
    return (
        <Card>
            <H1 weight={500} size="20px" height="27px">
                {category}
            </H1>
            <Line marginTop="20px" />
            {openings.map((job, idx) => (
                <div key={idx} style={{ marginTop: '20px' }}>
                    <a href={`/jobs/${job.id}`}>
                        <P size="16px" height="22px">
                            {firstCharacterCapital(job.title)}
                        </P>
                    </a>
                    <P size="14px" height="19px" weight={300}>
                        {job?.location || 'USA'}
                    </P>
                </div>
            ))}
        </Card>
    )
}

const AboutUsPage = ({jobs}) => {
    const [currentOpenings, setCurrentOpenings] = useState(jobs)

    return (
        <>
            <JoinUsSection>
                <JoinUsText>
                    <H1>Join Us</H1>
                    <P>
                        We’re always looking for top talent to help diversify
                        and strengthen our teams.
                    </P>
                </JoinUsText>
                <Image src={CareersImage} />
            </JoinUsSection>
            <CurrentOpeningsSection>
                <div className="d-flex flex-column align-items-center">
                    <Line borderColor="1px solid #4A4E64" />
                    <P
                        size="40px"
                        height="55px"
                        marginTop="39px"
                        maxWidth="unset"
                        className="align-self-start"
                    >
                        Check out our current openings
                    </P>
                    <a href="/welcome/about_us" className="align-self-end">
                        <P size="16px" height="22px" maxWidth="unset">
                            Check out our company page for more information{' '}
                            <Image src={RightArrowIcon} />
                        </P>
                    </a>
                    <Line marginTop="39px" borderColor="1px solid #4A4E64" />
                </div>
                <Openings>
                  {Object.keys(currentOpenings).map((key, idx) => (
                    <DisplayOpening
                      key={idx}
                      category={key}
                      openings={currentOpenings[key]}
                    />
                  ))}
                </Openings>
                {
                     Object.keys(currentOpenings).length == 0 && 
                     (
                         <div style={{ marginTop: '20px',width:'100%', textAlign:'center' }}>
                             <p size="16px" height="22px">
                                 No Job Openings
                             </p>
                         </div>
                     )
                }
            </CurrentOpeningsSection>

            <LookingForWorkSection>
                <P size="30px" height="41px" style={{ maxWidth: 'unset' }}>
                    Want to find out more?
                </P>
                <Button
                    onClick={() => (window.location.href = '/welcome/about_us')}
                >
                    Meet Our Team
                </Button>
            </LookingForWorkSection>
        </>
    )
}

export default AboutUsPage
export {}
