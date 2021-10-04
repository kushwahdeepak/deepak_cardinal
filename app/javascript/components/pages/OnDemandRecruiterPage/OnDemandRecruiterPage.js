import React from 'react'
import Image from 'react-bootstrap/Image'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'

import ImageOne from '../../../../assets/images/on_demand_recruiter/image-one-on-demand.png'
import ImageTwo from '../../../../assets/images/on_demand_recruiter/image-two-on-demand.png'
import CourseraLogo from '../../../../assets/images/on_demand_recruiter/coursera-logo.svg'
import ColorLogo from '../../../../assets/images/on_demand_recruiter/color-logo.svg'
import AdobeLogo from '../../../../assets/images/on_demand_recruiter/adobe-logo.svg'
import RobinhoodLogo from '../../../../assets/images/on_demand_recruiter/robinhood-logo.svg'
import BoxLogo from '../../../../assets/images/on_demand_recruiter/box-logo.svg'
import PeterImage from '../../../../assets/images/on_demand_recruiter/peter-anthony.svg'
import PaulImage from '../../../../assets/images/on_demand_recruiter/paul-campbell.svg'
import AdministrationIcon from '../../../../assets/images/on_demand_recruiter/administration.svg'
import DataAnalyticsIcon from '../../../../assets/images/on_demand_recruiter/data-analytics.svg'
import DesignIcon from '../../../../assets/images/on_demand_recruiter/design.svg'
import DevOpsIcon from '../../../../assets/images/on_demand_recruiter/dev-ops.svg'
import FinanceIcon from '../../../../assets/images/on_demand_recruiter/finance.svg'
import HumanResourcesIcon from '../../../../assets/images/on_demand_recruiter/human-resources.svg'
import InformtionTechIcon from '../../../../assets/images/on_demand_recruiter/information-tech.svg'
import MarketingIcon from '../../../../assets/images/on_demand_recruiter/marketing.svg'
import ProductManagementIcon from '../../../../assets/images/on_demand_recruiter/product-management.svg'
import ProjectManagementIcon from '../../../../assets/images/on_demand_recruiter/project-management.svg'
import SalesIcon from '../../../../assets/images/on_demand_recruiter/sales.svg'
import SoftwareEngineeringIcon from '../../../../assets/images/on_demand_recruiter/software-engineering.svg'
import './styles/OnDemandRecruiterPagemodule.scss'
import {
    H1,
    P,
    Button,
    TopSection,
    Card,
} from './styles/OnDemandRecruiter.styled'

const IndustryCard = ({ image, industry }) => {
    return (
        <Card>
            <Image src={image} />
            <P
                size={13}
                height={18}
                marginTop={12}
                color="#606BE4"
                weight={800}
            >
                {industry}
            </P>
        </Card>
    )
}

const OnDemandRecruiterPage = () => {
    return (
        <>
            <TopSection>
                <Col sm={12} xl={7}>
                    <H1>Hire Top Recruiters</H1>
                    <P>
                        From Stanford, UC Berkeley, UCLA, UPenn, Columbia, or
                        Harvard
                    </P>
                    <div className="hire-btns" style={{ marginTop: '40px' }}>
                        <Button
                            onClick={() =>
                                (window.location.href = '/users/sign_in')
                            }
                        >
                            Hire a top recruiter
                        </Button>
                        <Button
                            onClick={() =>
                                (window.location.href = '/users/sign_in')
                            }
                            marginLeft={15}
                        >
                            Become a top recruiter
                        </Button>
                    </div>
                    <div
                        className="d-lg-flex flex-wrap hire-logo"
                        style={{ marginTop: '53px' }}
                    >
                        <Image
                            src={CourseraLogo}
                            style={{ marginRight: '76px' }}
                        />
                        <Image
                            src={ColorLogo}
                            style={{ marginRight: '76px' }}
                        />
                        <Image
                            src={AdobeLogo}
                            style={{ marginRight: '76px' }}
                        />
                        <Image
                            src={RobinhoodLogo}
                            style={{ marginRight: '76px' }}
                        />
                        <Image src={BoxLogo} />
                    </div>
                </Col>
                <Col sm={5} className="d-none d-xl-block">
                    <Image
                        src={ImageOne}
                        style={{
                            position: 'absolute',
                            bottom: '0',
                            right: '210px',
                            zIndex: '2',
                        }}
                    />
                    <Image
                        src={ImageTwo}
                        style={{
                            position: 'absolute',
                            top: '0',
                            right: '0',
                        }}
                    />
                </Col>
            </TopSection>

            <TopSection
                style={{ paddingTop: '60px' }}
                className="d-flex flex-column"
            >
                <P
                    size={24}
                    height={33}
                    marginTop={0}
                    color="#424A73"
                    className="align-self-center"
                >
                    Work with our top recruiters
                </P>
                <Row
                    className="d-flex justify-content-around"
                    style={{ marginTop: '30px' }}
                >
                    <div className="d-flex flex-column align-items-center">
                        <Image src={PeterImage} />
                        <P size={12} height={16} marginTop={7} color="#272E50">
                            Peter Anthony
                        </P>
                    </div>
                    <div className="d-flex flex-column align-items-center">
                        <Image src={PaulImage} />
                        <P size={12} height={16} marginTop={7} color="#272E50">
                            Paul Campbell
                        </P>
                    </div>
                    <div className="d-flex flex-column align-items-center">
                        <Image src={PeterImage} />
                        <P size={12} height={16} marginTop={7} color="#272E50">
                            Peter Anthony
                        </P>
                    </div>
                    <div className="d-flex flex-column align-items-center">
                        <Image src={PaulImage} />
                        <P size={12} height={16} marginTop={7} color="#272E50">
                            Paul Campbell
                        </P>
                    </div>
                    <div className="d-flex flex-column align-items-center">
                        <Image src={PeterImage} />
                        <P size={12} height={16} marginTop={7} color="#272E50">
                            Peter Anthony
                        </P>
                    </div>
                </Row>
            </TopSection>

            <TopSection
                style={{ paddingTop: '42px' }}
                className="d-flex flex-column"
            >
                <P
                    size={24}
                    height={33}
                    marginTop={0}
                    color="#424A73"
                    className="align-self-center"
                >
                    Find a top recruiter for any industry
                </P>
                <Row className="industry-icon"
                    style={{
                        marginTop: '30px',
                        display: 'flex',
                        justifyContent: 'space-between',
                    }}
                >
                    <IndustryCard
                        image={AdministrationIcon}
                        industry="Administartion"
                    />
                    <IndustryCard
                        image={DataAnalyticsIcon}
                        industry="Data Analytics"
                    />
                    <IndustryCard image={DesignIcon} industry="Design" />
                    <IndustryCard image={DevOpsIcon} industry="Dev-Ops" />
                    <IndustryCard image={FinanceIcon} industry="Finance" />
                    <IndustryCard
                        image={HumanResourcesIcon}
                        industry="Human Resources"
                    />
                </Row>
                <Row className="industry-icon"
                    style={{
                        marginTop: '10px',
                        marginBottom: '90px',
                        display: 'flex',
                        justifyContent: 'space-between',
                    }}
                >
                    <IndustryCard
                        image={InformtionTechIcon}
                        industry="Information Tech"
                    />
                    <IndustryCard image={MarketingIcon} industry="Marketing" />
                    <IndustryCard
                        image={ProductManagementIcon}
                        industry="Product Management"
                    />
                    <IndustryCard
                        image={ProjectManagementIcon}
                        industry="Project Management"
                    />
                    <IndustryCard image={SalesIcon} industry="Sales" />
                    <IndustryCard
                        image={SoftwareEngineeringIcon}
                        industry="Software Engineering"
                    />
                </Row>
            </TopSection>
        </>
    )
}

export default OnDemandRecruiterPage
