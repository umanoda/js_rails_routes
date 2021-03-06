RSpec.describe JSRailsRoutes::Generator do
  let(:generator) do
    described_class.clone.instance
  end

  it { expect(described_class).to include(Singleton) }

  describe '#generate' do
    subject do
      generator.generate(task)
    end

    let(:task) do
      'js:routes'
    end

    it 'writes a JS file' do
      expect(generator).to receive(:write).with(a_string_including("rake #{task}"))
      subject
    end

    context 'when includes is given' do
      before do
        generator.includes = Regexp.new(includes)
      end

      let(:includes) do
        '/new'
      end

      it 'writes paths matching with the parameter' do
        expect(generator).to receive(:write).with(a_kind_of(String)) do |arg|
          paths = arg.split("\n")[1..-1]
          expect(paths).not_to be_empty
          expect(paths).to all(a_string_including(includes))
        end
        subject
      end
    end

    context 'when excludes is given' do
      before do
        generator.excludes = Regexp.new(excludes)
      end

      let(:excludes) do
        '/new'
      end

      it 'writes paths not matching with the parameter' do
        expect(generator).to receive(:write).with(a_kind_of(String)) do |arg|
          paths = arg.split("\n")[1..-1]
          expect(paths).not_to be_empty
          paths.each do |path|
            expect(path).to_not include(excludes)
          end
        end
        subject
      end
    end
  end
end
