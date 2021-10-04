export const Legends = [
  { name: 'Lead', key: 'leads', fill: 'rgba(255, 114, 114, 0.8)' },
  {
    name: 'ActiveCandidates',
    key: 'archive',
    fill: 'rgba(15, 70, 171, 0.8)',
  },
  {
    name: 'Applicants',
    key: 'applicants',
    fill: 'rgba(255, 198, 114, 0.8)',
  },
  {
    name: 'RecruiterScreen',
    key: 'recruiter_screen',
    fill: 'rgba(255, 241, 114, 0.8)',
  },
  {
    name: 'Submitted',
    key: 'submitted',
    fill: 'rgba(255, 241, 114, 0.8)',
  },
  {
    name: '1stInterview',
    key: 'first_interview',
    fill: 'rgba(201, 255, 114, 0.8)',
  },
  {
    name: '2ndInterview',
    key: 'second_interview',
    fill: 'rgba(114, 255, 230, 0.8)',
  },
  { name: 'Offers', key: 'offers', fill: 'rgba(114, 170, 255, 0.8)' },
  {
    name: 'Archived',
    key: 'archived',
    fill: 'rgba(150, 114, 255, 0.8)',
  }
]

export function getBarChartData() {
  return [
    {
      name: 'Leads',
      count: 0,
      fill: 'rgba(255, 114, 114, 0.8)',
    },
    {
      name: 'Active Candidates',
      count: 0,
      fill: 'rgba(15, 70, 171, 0.8)',
    },
    {
      name: 'Applicants',
      count: 0,
      fill: 'rgba(255, 198, 114, 0.8)',
    },
    {
      name: 'Recruiter screen',
      count: 0,
      fill: 'rgba(255, 241, 114, 0.8)',
    },
    {
      name: 'Submitted',
      count: 0,
      fill: 'rgba(255, 241, 114, 0.8)',
    },
    {
      name: '1st Interview',
      count: 0,
      fill: 'rgba(201, 255, 114, 0.8)',
    },
    {
      name: '2nd Interview',
      count: 0,
      fill: 'rgba(114, 255, 230, 0.8)',
    },
    {
      name: 'Offers',
      count: 0,
      fill: 'rgba(114, 170, 255, 0.8)',
    },
    {
      name: 'Archived',
      count: 0,
      fill: 'rgba(150, 114, 255, 0.8',
    }
  ]
}
