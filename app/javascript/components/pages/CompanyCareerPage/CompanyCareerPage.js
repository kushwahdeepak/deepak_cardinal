import React, { useState, useEffect } from 'react'
import { Image } from 'react-bootstrap'

import Logo from '../../../../assets/images/recruiter_page_assets/logo.png'
import SearchIcon from '../../../../assets/images/icons/search-icon.svg'
import Paginator from '../../common/Paginator/Paginator'
import {
    HeaderWithLogo,
    Container,
    H1,
    P,
    JobCategory,
    Circle,
    AboutCompany,
    Div,
    SearchField,
} from './styles/CompanyCareerPage.styled'

const companyCareersPage = () => {
    const [openCareers, setOpenCareers] = useState([])
    const [searchTerm, setSearchTerm] = useState('')
    const [activePage, setActivePage] = useState(0)
    const [pageCount, setPageCount] = useState(0)
    const description = `Pinterest's mission is to bring everyone the inspiration to create a life they love. It’s the biggest dataset of ideas ever assembled, with over 100 billion recipes, home hacks, style inspiration and other ideas to try. More than 440 million people around the world use Pinterest to dream about, plan and prepare for things they want to do in life.`

    useEffect(() => {
        // todo fetch data from backend
        setOpenCareers([
            {
                title: 'Backend Systems Engineer',
                location: 'San Francisco, CA',
                category: 'Engineering',
                color: '#EAEBFF',
                textColor: '#4461FF',
            },
            {
                title: 'Senior Recruiter',
                location: 'San Francisco, CA',
                category: 'Human Resources',
                color: '#EAFAFF',
                textColor: '#0E89BE',
            },
            {
                title: 'Product Designer',
                location: 'Remote',
                category: 'Design',
                color: '#F4EAFF',
                textColor: '#822AF1',
            },
            {
                title: 'Senior Marketing Associate',
                location: 'San Francisco, CA',
                category: 'Marketing',
                color: '#FFEAEA',
                textColor: '#DE2208',
            },
            {
                title: 'Sales Development Representative',
                location: 'San Francisco, CA',
                category: 'Sales',
                color: '#EAFFEB',
                textColor: '#19AE66',
            },
        ])
    }, [])
    return (
        <>
            <HeaderWithLogo>
                <div className="logo">
                    <Image src={Logo} />
                </div>
            </HeaderWithLogo>
            <Container>
                <div
                    className="d-flex flex-column"
                    style={{ marginTop: '90px' }}
                >
                    <H1>Pinterest</H1>
                    <div className="d-flex flex-column flex-sm-row align-items-center">
                        <JobCategory>
                            <P
                                size="20px"
                                height="27px"
                                weight={300}
                                color="#4461FF;"
                            >
                                Internet
                            </P>
                        </JobCategory>
                        <Circle
                            marginLeft="25px"
                            className="d-none d-sm-block"
                        />
                        <P
                            weight="300"
                            size="20px"
                            height="27px"
                            marginLeft="25px"
                        >
                            1,001-5,000 employees
                        </P>
                        <Circle
                            marginLeft="25px"
                            className="d-none d-sm-block"
                        />
                        <P
                            weight="300"
                            size="20px"
                            height="27px"
                            marginLeft="25px"
                        >
                            San Francisco, CA
                        </P>
                    </div>
                </div>
                <Div style={{ marginTop: '35px', display: 'flex' }}>
                    <AboutCompany>
                        <P
                            size="20px"
                            height="27px"
                            weight={500}
                            color="#A3AEE8"
                        >
                            About
                        </P>
                        <P
                            size="16px"
                            height="22px"
                            marginTop="15px"
                            dangerouslySetInnerHTML={{ __html: description }}
                        ></P>
                    </AboutCompany>
                    <div className="careers">
                        <div className="d-flex justify-content-between align-items-center">
                            <P
                                size="20px"
                                height="27px"
                                weight={500}
                                color="#A3AEE8"
                            >
                                Careers
                            </P>

                            <SearchField>
                                <Image src={SearchIcon} />
                                <input
                                    type="text"
                                    placeholder="Search jobs or departments"
                                    value={searchTerm}
                                    onChange={(e) =>
                                        setSearchTerm(e.target.value)
                                    }
                                />
                            </SearchField>
                        </div>
                        <div style={{ marginTop: '37px' }}>
                            {openCareers.map((career, idx) => (
                                <DisplayCareer key={idx} career={career} />
                            ))}
                        </div>
                        {pageCount > 0 && (
                            <div className="d-flex justify-content-center">
                                <Paginator
                                    pageCount={0}
                                    pageWindowSize={5}
                                    activePage={activePage}
                                    setActivePage={setActivePage}
                                />
                            </div>
                        )}
                    </div>
                </Div>
            </Container>
        </>
    )
}

const DisplayCareer = ({ career }) => {
    const { title, location, category, color, textColor } = career

    return (
        <div
            style={{
                borderBottom: '1px solid #E4E9FF',
                paddingBottom: '24px',
                marginBottom: '22px',
            }}
        >
            <P size="20px" height="27px">
                {title}
            </P>
            <div
                style={{
                    marginTop: '5px',
                    display: 'flex',
                    alignItems: 'baseline',
                }}
            >
                <P size="16px" height="22px">
                    {location}
                </P>
                <div
                    style={{
                        background: color,
                        borderRadius: '5px',
                        padding: '6px 12px',
                        marginLeft: '20px',
                    }}
                >
                    <P size="10px" height="14px" color={textColor}>
                        {category}
                    </P>
                </div>
            </div>
        </div>
    )
}

export default companyCareersPage
