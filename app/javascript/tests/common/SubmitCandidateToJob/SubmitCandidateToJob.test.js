import React from 'react';
import SubmitCandidateToJob from '../../../components/common/SubmitCandidateToJob/SubmitCandidateToJob';
import renderer from 'react-test-renderer';
import { configure, shallow, mount } from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
import { findByTestAttr } from '../../../utils';

configure({adapter: new Adapter()});

const initialShallowRender = (props = {}) => {
	return shallow(<SubmitCandidateToJob {...props}/>);
};

const initialMountRender = (props = {}) => {
	return mount(<SubmitCandidateToJob {...props}/>);
};


describe('SubmitCandidateToJob component',  () => {
	let wrapper;
	let fullWrapper;

	beforeEach(() => {

		const props = {
			jobs: [
				{
					id: 'MockId',
					label: 'Mock label',
					company: 'Mock Company',
					searchString: 'Mock Search String'
				}
			]
		};
		wrapper = initialShallowRender(props);
		fullWrapper = initialMountRender(props);
	});

	afterEach(() => {
		fullWrapper.unmount();
	});

	it('should render SubmitCandidateToJob component', () => {
		expect(wrapper.exists()).toBe(true);
	});

	it('should match with a snapshot', () => {
		const component = renderer.create(<SubmitCandidateToJob />);
		let tree = component.toJSON();
		expect(tree).toMatchSnapshot();
	});

});
