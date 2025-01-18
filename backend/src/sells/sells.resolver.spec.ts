import { Test, TestingModule } from '@nestjs/testing';
import { SellsResolver } from './sells.resolver';

describe('SellsResolver', () => {
  let resolver: SellsResolver;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [SellsResolver],
    }).compile();

    resolver = module.get<SellsResolver>(SellsResolver);
  });

  it('should be defined', () => {
    expect(resolver).toBeDefined();
  });
});
