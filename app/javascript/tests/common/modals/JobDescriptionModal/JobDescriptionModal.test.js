import React from 'react';
import JobDescriptionModal from '../../../../components/common/modals/JobDescriptionModal/JobDescriptionModal';
import renderer from 'react-test-renderer';
import { configure, shallow, mount } from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
import { findByTestAttr } from '../../../../utils';

configure({adapter: new Adapter()});

const initialShallowRender = (props = {}) => {
	return shallow(<JobDescriptionModal {...props}/>);
};

const initialMountRender = (props = {}) => {
	return mount(<JobDescriptionModal {...props}/>);
};


describe('JobDescriptionModal component',  () => {
	let wrapper;
	let fullWrapper;

	beforeEach(() => {

		const props = {
			job: {location: 'Mock location'}
		};
		wrapper = initialShallowRender(props);
		fullWrapper = initialMountRender(props);
	});

	afterEach(() => {
		fullWrapper.unmount();
	});

	it('should render JobDescriptionModal component', () => {
		expect(wrapper.exists()).toBe(true);
	});

	it('should match with a snapshot', () => {
		const props = {
			job: {location: 'Mock location'}
		};

		const component = renderer.create(<JobDescriptionModal {...props} />);
		let tree = component.toJSON();
		expect(tree).toMatchSnapshot();
	});

	describe('JobDescriptionModal component with props', () => {

	});
	describe('JobDescriptionModal component without props', () => {

	});

});
