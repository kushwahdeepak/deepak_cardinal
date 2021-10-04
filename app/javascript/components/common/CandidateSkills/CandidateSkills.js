import React from 'react'
import styles from './styles/CandidateSkills.module.scss'
import { capitalize, stringReplace, skillIsNotEmpty } from '../../../utils'

const CandidateSkills = (props) => {
    const { skills } = props

    if(skills == null || skills.length == 0) return ''
    const skills_asc = (skills.split(',')).sort((a,b) => a.length - b.length);
    return(
      <div className={styles.Skills}>
        {
          skills_asc.map((skill, index) => (
            skillIsNotEmpty(skill) && <span key={index}>{capitalize(stringReplace(skill,'_',' '))}</span>
          ))
        }
      </div>
    );
}

export default CandidateSkills
