import React, { useEffect, useReducer, useState } from 'react'
import Image from 'react-bootstrap/Image'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import styles from './styles/CompanyProfilePage.module.scss'
import { FormControl } from 'react-bootstrap'
import Modal from '../../common/Styled components/Modal'
import EditCompanyProfile from './EditCompanyProfile'
import Search from '../../../../assets/images/talent_page_assets/search-icon-new.png'
import { reducer, StoreCompanyContext } from '../../../stores/CompanyProfileStore'
import CompanyPlaceholderImage from '../../../../assets/images/talent_page_assets/company-placeholder.png'

const getCompanySize = (param) => {
  switch(param) {
    case 1:
      return '0-1';
    case 2:
      return '2-10';
    case 11:
      return '11-50';
    case 51:
      return '51-200';
    case 201:
      return '201-500';
    case 501:
      return '501-1,000';
    case 1001:
      return '1,001-5,000';
    case 5001:
      return '5,001-10,000';
    case 10001:
      return '10,001+'
    default:
      return '0';
  }
}

const CompanyProfilePage = (props) => {
    const {organization, jobs, logo_url, isEmployer} = props
    const {id, name, description, industry, min_size, max_size, city, region, company_size, country} = organization
    const [open,setOpen]=useState(false)
    let initialState = { 
      ...initialState, 
      ...{id, name, description,industry, min_size, max_size, region, city, country, jobs, logo_url: logo_url, company_size, isEmployer},
      ...{companySizes: [], industries: []}
    }
    const [state, dispatch] = useReducer(reducer, initialState)
    const [searchTerm, setSearchTerm] = useState("");
    const [jobsData, setSearchResults] = useState(state.jobs);
    const handleChange = event => {
      setSearchTerm(event.target.value);
    };

    const format_logo_url = (avatar_url) => {
      if(typeof avatar_url == "object"){
        return(URL.createObjectURL(avatar_url))
      }
      return avatar_url
    }

    useEffect(() => {
        
      const results = state.jobs.filter(job =>{
        return job.name.toLowerCase().includes(searchTerm.toLowerCase()) || job.department.toLowerCase().includes(searchTerm.toLowerCase())
      });
      setSearchResults(results);
      if(searchTerm == ''){
        const results = state.jobs;
        setSearchResults(results);
      }

      const lookupsUrl = '/signup/lookups'
      fetch(lookupsUrl)
      .then(res => res.json())
      .then(
        (result) => {
          const {company_sizes, industries} = result
          dispatch({
            type: 'set_company_size_and_industry_types',
            value: {companySizes: [...company_sizes], industries: [...industries] }
          })
        },
        (error) => {
          console.log(error);
        }
      )
    }, [searchTerm]);
    return (
      <StoreCompanyContext.Provider value={{ state, dispatch }}>
        <div className="candidate-view-profile-page">
            <div className={`${styles.profileHeading} jumbotron jumbotron-fluid`}>
                <div className="container">
                </div>
            </div>
            <div className="container">
                <div className={`${styles.profileImageSection}`}>
                    <Row>
                        <Col xs={12} sm={12} md={6} lg={6}>
                            <Image
                                src={state.logo_url == null ? CompanyPlaceholderImage : format_logo_url(state.logo_url)}
                                className={`${styles.profileImage}`}
                            />
                        </Col>
                        <Col xs={12} sm={12} md={6} lg={6}>
                            {state.isEmployer && 
                              <button className={`${styles.editProfileButton}`} onClick={()=>setOpen(!open)}>
                                  Edit Organizations Profile
                              </button>
                            }
                            <Modal isOpen={open} s onBlur={() => setOpen(!open)}>
                                <EditCompanyProfile 
                                  open={open}
                                  setOpen={setOpen}
                                  format_logo_url={format_logo_url}
                                  organization={organization}
                                />
                            </Modal>
                        </Col>
                    </Row>
                </div>
                <Row>
                    <Col xs={12}>
                        <h2 className={`${styles.profileName} mt-2`}>
                            {state.name}
                        </h2>
                    </Col>
                    <Col xs={12} className={`${styles.profileheading} d-flex`}>
                      <div className='main-label d-flex'>
                        <span className="pr-4">{state.industry}</span>
                        <span style={{color:'#E3E7FE'}}>&#9679;</span>
                        <span className="pl-4 pr-4">{state?.company_size === 0 ? '0-1 Employee' : state?.company_size !== 0 ? `${getCompanySize(state.company_size)} Employees` : ''}</span>
                        <span style={{color:'#E3E7FE'}}>&#9679;</span>
                        <span className="pl-4">{state.city}{(state.city && state.region) && ', ' }{state.region}</span>
                      </div>
                    </Col>
                </Row>
                <Row className="mt-5 mb-5">
                    <Col xs={12} sm={12} md={4} lg={4}>
                        <div className={`${styles.profileAboutme}`}>
                            <h4 className={`${styles.profileHeadingTitle}`} >About Organization</h4>
                            <AboutMe description = {state.description || ''} />
                        </div>
                    </Col>
                    <Col xs={12} sm={12} md={8} lg={8}>
                        <div className="d-flex justify-content-between">
                            <div>
                                <h4 className={`${styles.jobTitle} ml-3`}>Careers</h4>
                            </div>
                            <div className={`form-group ${styles.hasSearch}`}>
                                <span className={styles.formControlFeedback}><img width={20} height={20} src={Search} /></span>
                                <FormControl type="text" className={`form-control ${styles.formControl}`} value={searchTerm} onChange={handleChange} placeholder="Search jobs or departments" aria-label="Search"/>
                            </div>
                        </div>
                      <Careers jobs={jobsData} />  
                    </Col>
                </Row>
            </div>
        </div>
      </StoreCompanyContext.Provider>
    )
}


function Careers({jobs}) {
  if(jobs.length == 0) return('No jobs found')
  return(
    <>
      {
         jobs.map((career, index) => (
          <a href={`/jobs/${career.id}`}>
            <div className={`${styles.career}`} key={index}>
                <h5 className={`${styles.careerHeader}`}>{career.name}</h5>
                <label className={`alert-success ${styles.careerLabel}`}>{career.department || 'No department found'}</label>
                <div className='clearfix'></div>
                <span className={`${styles.careerDetail}`}>{career.city}{(career.city && career.state) && ' , ' }{career.state}</span>
            </div>
          </a>
        ))
      }
    </>
  )
}

function AboutMe({description}) {
  if(description === '') return 'No description found'
  return(
    <>
      <p className={`${styles.profileDetail}`}>{description}</p>
    </>
  );
}

export default CompanyProfilePage