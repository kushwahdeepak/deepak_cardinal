import React from 'react';
import TagInput from '../../../../components/common/inputs/TagInput/TagInput';
import renderer from 'react-test-renderer';
import { configure, shallow, mount } from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
import { findByTestAttr } from '../../../../utils';

configure({adapter: new Adapter()});

const initialShallowRender = (props = {}) => {
	return shallow(<TagInput {...props}/>);
};

const initialMountRender = (props = {}) => {
	return mount(<TagInput {...props}/>);
};


describe('TagInput component',  () => {
	let wrapper;
	let fullWrapper;

	beforeEach(() => {

		const props = {
		};
		wrapper = initialShallowRender(props);
		fullWrapper = initialMountRender(props);
	});

	afterEach(() => {
		fullWrapper.unmount();
	});

	it('should render TagInput component', () => {
		expect(wrapper.exists()).toBe(true);
	});

	it('should match with a snapshot', () => {
		const component = renderer.create(<TagInput />);
		let tree = component.toJSON();
		expect(tree).toMatchSnapshot();
	});

	describe('TagInput component with props', () => {

	});
	describe('TagInput component without props', () => {

	});
});
